# Side-by-Side Graph Comparison Presentation

A minimal LaTeX Beamer presentation designed for visual inspection and parity validation between **R (`ggplot2`)** and **Stata** graph outputs.

---

## Slide Architecture & Design

- **Purely Plain Slides**: All Beamer headers, footers, navigation symbols, and themes are suppressed (`\begin{frame}[plain]` with empty templates).
- **Aspect Ratio**: 16:9 widescreen (`aspectratio=169`), optimizing horizontal space for two landscape charts.
- **Side-by-Side Layout**:
  - **Left**: R figure (`../output_checks/r_<suffix>`)
  - **Right**: Stata figure (`../output_checks/stata_<suffix>`)
- **Scaling**: Each graphic is scaled to `0.495\linewidth` and `0.96\textheight` with `keepaspectratio`, ensuring maximum size without clipping or distortion.

---

## Current Discovered Graphs

The presentation currently contains slides for all matching graph suffixes discovered in `output_checks/`:

1. `bar` (`r_bar.png` vs. `stata_bar.png`)
2. `facet` (`r_facet.png` vs. `stata_facet.png`)
3. `scatter` (`r_scatter.png` vs. `stata_scatter.png`)

---

## Updating When Graphs Change

As new test figures are added to or updated in `output_checks/`:

### Option 1: Automatic Update Script (Recommended)
Run either script from within `latex/` or repository root:

- **PowerShell (Windows)**:
  ```powershell
  .\latex\update.ps1
  ```
- **Bash (Linux / macOS / Git Bash)**:
  ```bash
  ./latex/update.sh
  ```

These scripts scan `output_checks/` for all `r_*` and `stata_*` files, extract all matching suffixes, rewrite `presentation.tex`, and compile `presentation.pdf`.

### Option 2: Direct LaTeX Editing
You can add or modify suffixes directly in the `\foreach \suffix in { ... }` block in `presentation.tex`:

```latex
\foreach \suffix in {
  bar,
  facet,
  scatter,
  your_new_suffix
}
```

Then compile with:
```bash
pdflatex presentation.tex
```
