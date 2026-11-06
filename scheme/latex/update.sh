#!/usr/bin/env bash
# ==============================================================================
# update.sh
# Discovers all matching r_ and stata_ graph pairs in /output_checks/,
# updates presentation.tex, and compiles presentation.pdf with graph metadata.
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKS_DIR="$SCRIPT_DIR/../output_checks"

if [ ! -d "$CHECKS_DIR" ]; then
  echo "Error: Output checks directory not found: $CHECKS_DIR"
  exit 1
fi

# Find suffixes common to both r_* and stata_*
suffixes=()
for r_file in "$CHECKS_DIR"/r_*; do
  [ -f "$r_file" ] || continue
  filename=$(basename "$r_file")
  base="${filename#r_}"
  suffix="${base%.*}"

  for stata_file in "$CHECKS_DIR"/stata_"$suffix".*; do
    if [ -f "$stata_file" ]; then
      suffixes+=("$suffix")
      break
    fi
  done
done

# Sort unique suffixes
IFS=$'\n' sorted_suffixes=($(sort -u <<<"${suffixes[*]}"))
unset IFS

echo "Discovered ${#sorted_suffixes[@]} matching graph pairs in output_checks:"
for s in "${sorted_suffixes[@]}"; do
  echo "  - $s"
done

if [ ${#sorted_suffixes[@]} -eq 0 ]; then
  echo "Warning: No matching r_* and stata_* graph pairs found."
  exit 0
fi

get_r_style() {
  case "$1" in
    area)      echo "geom\_area(position = 'stack')" ;;
    bar)       echo "geom\_col() + coord\_flip()" ;;
    box)       echo "geom\_boxplot()" ;;
    bubble)    echo "geom\_point(aes(size = ...))" ;;
    density)   echo "geom\_density()" ;;
    dot)       echo "geom\_segment() + geom\_point()" ;;
    dumbbell)  echo "geom\_segment() + geom\_point()" ;;
    ecdf)      echo "stat\_ecdf(geom = 'step')" ;;
    facet)     echo "geom\_point() + facet\_wrap()" ;;
    forest)    echo "geom\_errorbar() + geom\_point()" ;;
    histogram) echo "geom\_histogram() + geom\_density()" ;;
    line)      echo "geom\_line()" ;;
    lollipop)  echo "geom\_segment() + geom\_point()" ;;
    pyramid)   echo "geom\_col() + geom\_vline()" ;;
    ribbon)    echo "geom\_ribbon() + geom\_line()" ;;
    scatter)   echo "geom\_point() + geom\_smooth(lm)" ;;
    *)         echo "geom\_${1//_/\\_}" ;;
  esac
}

get_stata_type() {
  case "$1" in
    area)      echo "twoway area" ;;
    bar)       echo "graph hbar, asyvars" ;;
    box)       echo "graph box, asyvars" ;;
    bubble)    echo "twoway scatter [w=...]" ;;
    density)   echo "twoway kdensity (area + line)" ;;
    dot)       echo "graph dot, asyvars" ;;
    dumbbell)  echo "twoway rspike + scatter" ;;
    ecdf)      echo "cumul + twoway line" ;;
    facet)     echo "twoway scatter, by()" ;;
    forest)    echo "twoway rcap + scatter" ;;
    histogram) echo "twoway histogram + kdensity" ;;
    line)      echo "twoway line" ;;
    lollipop)  echo "twoway dropline" ;;
    pyramid)   echo "twoway bar, horizontal" ;;
    ribbon)    echo "twoway rarea + line" ;;
    scatter)   echo "twoway lfitci + scatter" ;;
    *)         echo "graph ${1//_/\\_}" ;;
  esac
}

list_formatted=""
for i in "${!sorted_suffixes[@]}"; do
  s="${sorted_suffixes[$i]}"
  r_style=$(get_r_style "$s")
  stata_type=$(get_stata_type "$s")
  entry="  $s/{$r_style}/{$stata_type}"
  if [ $i -eq $((${#sorted_suffixes[@]} - 1)) ]; then
    list_formatted+="$entry"
  else
    list_formatted+="$entry,"$'\n'
  fi
done

cat << 'EOF' > "$SCRIPT_DIR/presentation.tex"
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
EOF

echo "$list_formatted" >> "$SCRIPT_DIR/presentation.tex"

cat << 'EOF' >> "$SCRIPT_DIR/presentation.tex"
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
EOF

echo "Updated $SCRIPT_DIR/presentation.tex"
echo "Compiling presentation.tex with pdflatex..."
cd "$SCRIPT_DIR" && pdflatex -interaction=nonstopmode presentation.tex
echo "Successfully compiled presentation.pdf (${#sorted_suffixes[@]} slides)."
