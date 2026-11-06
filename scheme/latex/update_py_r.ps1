# ==============================================================================
# update_py_r.ps1
# Discovers all matching r_ and py_ graph pairs in /output_checks/,
# updates presentation_py_r.tex, and compiles presentation_py_r.pdf.
# ==============================================================================

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputChecksDir = Join-Path $scriptDir "..\output_checks"

if (-not (Test-Path $outputChecksDir)) {
    Write-Error "Output checks directory not found: $outputChecksDir"
    exit 1
}

# Discover suffixes from r_ and py_ files
$rSuffixes = Get-ChildItem -Path "$outputChecksDir\r_*" -File | ForEach-Object {
    $_.BaseName -replace '^r_', ''
}

$pySuffixes = Get-ChildItem -Path "$outputChecksDir\py_*" -File | ForEach-Object {
    $_.BaseName -replace '^py_', ''
}

# Keep only suffixes present in both sets
$suffixes = $rSuffixes | Where-Object { $pySuffixes -contains $_ } | Sort-Object -Unique

Write-Host "Discovered $($suffixes.Count) matching graph pairs in output_checks:" -ForegroundColor Cyan
$suffixes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Green }

if ($suffixes.Count -eq 0) {
    Write-Warning "No matching r_* and py_* graph pairs found."
    exit 0
}

# Metadata mapping: Suffix -> @{ r = "R Style"; py = "Python Style" }
$meta = @{
    "area"      = @{ r = "geom\_area(position = 'stack')"; py = "ax.stackplot()" }
    "bar"       = @{ r = "geom\_col() + coord\_flip()"; py = "ax.barh()" }
    "box"       = @{ r = "geom\_boxplot()"; py = "ax.bxp()" }
    "bubble"    = @{ r = "geom\_point(aes(size = ...))"; py = "ax.scatter(s=...)" }
    "density"   = @{ r = "geom\_density()"; py = "gaussian\_kde() + fill\_between()" }
    "dot"       = @{ r = "geom\_segment() + geom\_point()"; py = "ax.hlines() + ax.scatter()" }
    "dumbbell"  = @{ r = "geom\_segment() + geom\_point()"; py = "ax.hlines() + ax.scatter()" }
    "ecdf"      = @{ r = "stat\_ecdf(geom = 'step')"; py = "ax.step(where='post')" }
    "facet"     = @{ r = "geom\_point() + facet\_wrap()"; py = "plt.subplots(1, 2)" }
    "forest"    = @{ r = "geom\_errorbar() + geom\_point()"; py = "ax.errorbar()" }
    "histogram" = @{ r = "geom\_histogram() + geom\_density()"; py = "ax.hist() + kde" }
    "line"      = @{ r = "geom\_line()"; py = "ax.plot()" }
    "lollipop"  = @{ r = "geom\_segment() + geom\_point()"; py = "ax.vlines() + ax.scatter()" }
    "pyramid"   = @{ r = "geom\_col() + geom\_vline()"; py = "ax.barh(left=...)" }
    "ribbon"    = @{ r = "geom\_ribbon() + geom\_line()"; py = "ax.fill\_between() + ax.plot()" }
    "scatter"   = @{ r = "geom\_point() + geom\_smooth(lm)"; py = "ax.scatter() + fit + CI" }
}

# Build multi-variable loop formatted for LaTeX \foreach \suffix / \rstyle / \pystyle
$entries = foreach ($s in $suffixes) {
    if ($meta.ContainsKey($s)) {
        $rStyle = $meta[$s].r
        $pyStyle = $meta[$s].py
    } else {
        $escaped = $s -replace '_', '\_'
        $rStyle = "geom\_$escaped"
        $pyStyle = "plt.$escaped"
    }
    "  $s/{$rStyle}/{$pyStyle}"
}
$loopList = $entries -join ",`n"

# Generate presentation_py_r.tex
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
% R figure on the left, Python figure on the right
\foreach \suffix / \rstyle / \pystyle in {
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
        {\small \textbf{Python (\texttt{matplotlib}):} \texttt{\pystyle}}\\[0.25em]
        \includegraphics[width=\linewidth,height=0.85\textheight,keepaspectratio]{../output_checks/py_\suffix}
      \end{column}
    \end{columns}
  \end{frame}
}

\end{document}
"@

$texPath = Join-Path $scriptDir "presentation_py_r.tex"
[System.IO.File]::WriteAllText($texPath, $texContent, [System.Text.Encoding]::UTF8)
Write-Host "Updated $texPath" -ForegroundColor Cyan

# Check if presentation_py_r.pdf is currently locked by a PDF reader
$pdfPath = Join-Path $scriptDir "presentation_py_r.pdf"
if (Test-Path $pdfPath) {
    try {
        $fs = [System.IO.File]::Open($pdfPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
        $fs.Close()
    } catch {
        Write-Warning "presentation_py_r.pdf appears locked by a PDF viewer. Attempting to release..."
        Get-Process -Name Acrobat -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -eq 0 } | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
}

# Compile presentation with pdflatex
Set-Location $scriptDir
Write-Host "Compiling presentation_py_r.tex with pdflatex..." -ForegroundColor Cyan
& pdflatex -interaction=nonstopmode presentation_py_r.tex

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully compiled presentation_py_r.pdf ($($suffixes.Count) slides)." -ForegroundColor Green
} else {
    Write-Error "pdflatex compilation failed with exit code $LASTEXITCODE."
}
