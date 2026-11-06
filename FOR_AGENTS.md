# Agent Router: Wildcat System

> **Repository Context:**
> The [`wildcat`](https://github.com/aarondwolf/wildcat) repository provides official Northwestern University visual identity and branding tools across two synchronized components:
> 1. **LaTeX Beamer Theme** (`source/`): Modern presentation theme with geometric facet patterns, brand colors, custom blocks, and typography.
> 2. **Data Visualization Themes** (`scheme/`): Publication-grade graph themes for Stata, R (`ggplot2`), and Python (`matplotlib`).

If you are an AI coding agent tasked with setting up or modifying themes for a user, consult the specific sub-guide below based on what the user needs:

---

## 🎯 Task Router

### 1. Creating or Updating a Beamer Presentation
**Use case:** The user wants to create a new presentation, adapt an existing Beamer slide deck to the Wildcat theme, or download the necessary `.sty` theme files into their project folder.

👉 **Follow [`source/FOR_AGENTS.md`](source/FOR_AGENTS.md)**
*(or view online at [source/FOR_AGENTS.md](https://github.com/aarondwolf/wildcat/blob/main/source/FOR_AGENTS.md))*

- **Key instructions covered:**
  - How to fetch individual `.sty` and logo files directly from GitHub without cloning the entire repository.
  - Initializing a new presentation from a template or demo (`wildcat-demo.tex`).
  - Safely adapting an existing Beamer `.tex` file to `*_wildcat.tex`.
  - Managing font options (Fira Sans default, Noto, Poppins, Campton).
  - Compilation requirements (**XeLaTeX** or **LuaLaTeX** required; `pdflatex` is not supported).

---

### 2. Installing or Using Stata, R, or Python Graph Themes
**Use case:** The user wants to produce publication-ready figures in Stata, R, or Python that match Northwestern branding, or wants to customize brand colors, palettes, and rebuild schemes.

👉 **Follow [`scheme/FOR_AGENTS.md`](scheme/FOR_AGENTS.md)**
*(or view online at [scheme/FOR_AGENTS.md](https://github.com/aarondwolf/wildcat/blob/main/scheme/FOR_AGENTS.md))*

- **Key instructions covered:**
  - Installing `scheme-wildcat` into Stata via `net from "https://github.com/aarondwolf/wildcat/tree/main/scheme"` / `net install wildcat`.
  - Sourcing and applying `theme_wildcat.R` and `scale_color_wildcat()` in R `ggplot2`.
  - Loading `theme_wildcat.py` and `wildcat.mplstyle` in Python `matplotlib`.
  - Programmatic customization instructions to rename themes and define custom palettes across all three environments.
  - Running the 16-chart validation suite to ensure cross-platform visual parity.
