# ==============================================================================
# update.ps1
# Discovers all matching r_ and stata_ graph pairs in /output_checks/,
# updates presentation.tex, and compiles presentation.pdf with graph metadata.
# ==============================================================================

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputChecksDir = Join-Path $scriptDir "..\output_checks"

if (-not (Test-Path $outputChecksDir)) {
    Write-Error "Output checks directory not found: $outputChecksDir"
    exit 1
}

# Discover suffixes from r_ and stata_ files
$rSuffixes = Get-ChildItem -Path "$outputChecksDir\r_*" -File | ForEach-Object {
    $_.BaseName -replace '^r_', ''
}

$stataSuffixes = Get-ChildItem -Path "$outputChecksDir\stata_*" -File | ForEach-Object {
    $_.BaseName -replace '^stata_', ''
}

# Keep only suffixes present in both sets
$suffixes = $rSuffixes | Where-Object { $stataSuffixes -contains $_ } | Sort-Object -Unique

Write-Host "Discovered $($suffixes.Count) matching graph pairs in output_checks:" -ForegroundColor Cyan
$suffixes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Green }

if ($suffixes.Count -eq 0) {
    Write-Warning "No matching r_* and stata_* graph pairs found."
    exit 0
}

# Metadata mapping: Suffix -> @{ r = "R Style"; stata = "Stata Type" }
$meta = @{
    "area"      = @{ r = "geom\_area(position = 'stack')"; stata = "twoway area" }
    "bar"       = @{ r = "geom\_col() + coord\_flip()"; stata = "graph hbar, asyvars" }
    "box"       = @{ r = "geom\_boxplot()"; stata = "graph box, asyvars" }
    "bubble"    = @{ r = "geom\_point(aes(size = ...))"; stata = "twoway scatter [w=...]" }
    "density"   = @{ r = "geom\_density()"; stata = "twoway kdensity (area + line)" }
    "dot"       = @{ r = "geom\_segment() + geom\_point()"; stata = "graph dot, asyvars" }
    "dumbbell"  = @{ r = "geom\_segment() + geom\_point()"; stata = "twoway rspike + scatter" }
    "ecdf"      = @{ r = "stat\_ecdf(geom = 'step')"; stata = "cumul + twoway line" }
    "facet"     = @{ r = "geom\_point() + facet\_wrap()"; stata = "twoway scatter, by()" }
    "forest"    = @{ r = "geom\_errorbar() + geom\_point()"; stata = "twoway rcap + scatter" }
    "histogram" = @{ r = "geom\_histogram() + geom\_density()"; stata = "twoway histogram + kdensity" }
    "line"      = @{ r = "geom\_line()"; stata = "twoway line" }
    "lollipop"  = @{ r = "geom\_segment() + geom\_point()"; stata = "twoway dropline" }
    "pyramid"   = @{ r = "geom\_col() + geom\_vline()"; stata = "twoway bar, horizontal" }
    "ribbon"    = @{ r = "geom\_ribbon() + geom\_line()"; stata = "twoway rarea + line" }
    "scatter"   = @{ r = "geom\_point() + geom\_smooth(lm)"; stata = "twoway lfitci + scatter" }
}

# Build multi-variable loop formatted for LaTeX \foreach \suffix / \rstyle / \statatype
$entries = foreach ($s in $suffixes) {
    if ($meta.ContainsKey($s)) {
        $rStyle = $meta[$s].r
        $stataType = $meta[$s].stata
    } else {
        $escaped = $s -replace '_', '\_'
        $rStyle = "geom\_$escaped"
        $stataType = "graph $escaped"
    }
    "  $s/{$rStyle}/{$stataType}"
}
$loopList = $entries -join ",`n"

# Generate presentation.tex
$texContent = @"
\documentclass[aspectratio=169]{beamer}

% Suppress all slide decorations, headers, footers, and navigation symbols for a completely plain slide
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{headline}{}
\setbeamertemplate{footline}{}

\usepackage{graphicx}
\usepackage{pgffor}

% Minimize text margins so figures maximize available slide area
\setbeamersize{text margin left=0.1cm, text margin right=0.1cm}

\begin{document}

% Discovered matching suffixes from output_checks/
% R figure on the left, Stata figure on the right
\foreach \suffix / \rstyle / \statatype in {
$loopList
} {
  \begin{frame}[plain]
    \vspace{0.18cm}
    \centerline{{\large \textbf{Graph Suffix:} \texttt{\suffix}}}
    \vspace{0.14cm}
    \begin{columns}[T]
      \begin{column}{0.495\linewidth}
        \centering
        {\small \textbf{R (\texttt{ggplot2}):} \texttt{\rstyle}}\\[0.25em]
        \includegraphics[width=\linewidth,height=0.85\textheight,keepaspectratio]{../output_checks/r_\suffix}
      \end{column}
      \begin{column}{0.495\linewidth}
        \centering
        {\small \textbf{Stata:} \texttt{\statatype}}\\[0.25em]
        \includegraphics[width=\linewidth,height=0.85\textheight,keepaspectratio]{../output_checks/stata_\suffix}
      \end{column}
    \end{columns}
  \end{frame}
}

\end{document}
"@

$texPath = Join-Path $scriptDir "presentation.tex"
[System.IO.File]::WriteAllText($texPath, $texContent, [System.Text.Encoding]::UTF8)
Write-Host "Updated $texPath" -ForegroundColor Cyan

# Check if presentation.pdf is currently locked by a PDF reader
$pdfPath = Join-Path $scriptDir "presentation.pdf"
if (Test-Path $pdfPath) {
    try {
        $fs = [System.IO.File]::Open($pdfPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
        $fs.Close()
    } catch {
        Write-Warning "presentation.pdf appears locked by a PDF viewer (e.g., Acrobat). Attempting to release..."
        Get-Process -Name Acrobat -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq 0 } | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
}

# Compile presentation with pdflatex
Set-Location $scriptDir
Write-Host "Compiling presentation.tex with pdflatex..." -ForegroundColor Cyan
& pdflatex -interaction=nonstopmode presentation.tex

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully compiled presentation.pdf ($($suffixes.Count) slides)." -ForegroundColor Green
} else {
    Write-Error "pdflatex compilation failed with exit code $LASTEXITCODE."
}
