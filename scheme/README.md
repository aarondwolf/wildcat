# Wildcat Graph Theme System (Stata, R ggplot2 & Python Matplotlib)

> **Repository Context:**
> This directory is part of the [**Wildcat**](https://github.com/aarondwolf/wildcat) repository. While the parent repository provides a modern Northwestern University Beamer presentation theme, the `scheme/` folder houses the companion publication-grade graph styling system across **Stata** (`scheme-wildcat`), **R** (`theme_wildcat`), and **Python** (`theme_wildcat` / `wildcat.mplstyle`).

A unified, publication-grade graph theme and styling system featuring official **Northwestern University** branding. This system provides synchronized styling implementations for **Stata**, **R**, and **Python**, ensuring that figures produced across all three environments share an identical visual language, typographic hierarchy, and brand-compliant color palette anchored to R's `ggplot2` `theme_minimal()` aesthetic.

> [!TIP]
> **Working with an AI Coding Agent?**
> If you are using an AI coding agent (such as Claude, ChatGPT, Cursor, Copilot, or Gemini) to write scripts, create figures, or adapt these themes to a new institution or color palette, share [**`FOR_AGENTS.md`**](FOR_AGENTS.md) with the agent. It contains concise, structured instructions for downloading files, referencing them across all three languages, programmatically editing palettes, and maintaining visual parity.

---

## Quick Installation & Setup

### Stata Installation

#### Option 1: Official SSC Installation (Recommended)
Install the complete scheme, custom marker styles, and official Northwestern color style files directly from SSC:

```stata
* Install scheme, styles, and color definitions from SSC
ssc install wildcat, replace

* Set scheme permanently for all future Stata sessions
set scheme wildcat, permanently
```

#### Option 2: Install Latest Updates via `net install` (Optional)
To install the latest development version directly from GitHub:

```stata
* Install latest development version from GitHub
net from "https://raw.githubusercontent.com/aarondwolf/wildcat/main/scheme"
net describe wildcat
net install wildcat, replace

* Set scheme permanently for all future Stata sessions
set scheme wildcat, permanently
```

Once installed, you can apply the scheme in individual graph commands:
```stata
graph twoway scatter mpg weight, scheme(wildcat)
```

### R `ggplot2` Setup

Source the theme script or copy `r/theme_wildcat.R` into your project:

```r
source("r/theme_wildcat.R")

# Apply theme and discrete palette to any ggplot2 chart
ggplot(df, aes(x = x, y = y, color = group)) +
  geom_point() +
  scale_color_wildcat() +
  theme_wildcat()
```

### Python `matplotlib` Setup

The Python theme is provided in the `py/` folder via `theme_wildcat.py` and the standalone `wildcat.mplstyle` stylesheet:

```python
import matplotlib.pyplot as plt
import pandas as pd
from py.theme_wildcat import set_theme, wildcat_colors, labs, legend_top

# 1. Apply Wildcat theme globally (rcParams, typography, colors, padding)
set_theme()

# 2. Plot using standard Matplotlib or Pandas
fig, ax = plt.subplots(figsize=(8, 5))
ax.scatter(df["weight"], df["mpg"], color=wildcat_colors["nupurple"], s=28)

# 3. Add ggplot2-style titles, subtitles, and captions
labs(
    ax,
    title="Automobile Weight vs. Fuel Efficiency",
    subtitle="Linear relationship with Northwestern branding",
    x="Vehicle Weight (lbs.)",
    y="Mileage (mpg)",
    caption="Source: 1978 Automobile Data"
)

# 4. For multi-series plots, place the legend on top flush with the title
# legend_top(ax, ncol=2)

plt.savefig("figure.png", dpi=300)
```

#### Standalone Stylesheet Usage
If you prefer not to import the helper functions, you can load the stylesheet directly:
```python
import matplotlib.pyplot as plt
plt.style.use("py/wildcat.mplstyle")
```

#### Available Palettes in Python
The Python module provides the same discrete and continuous palettes as R and Stata:
- `set_theme(palette="default")`: 12-color balanced categorical sequence (`nupurple`, `nudarkorange`, `nubrightblue`, ...).
- `set_theme(palette="bright")`: Secondary bright palette.
- `set_theme(palette="dark")`: Secondary dark palette.
- `set_theme(palette="purple")`: 5-step purple monochromatic sequence.
- Colormaps: `cmap_wildcat_purple` and `cmap_wildcat_diverging` for heatmaps and continuous color scales.

---

## Directory Structure

The `scheme/` folder is structured for seamless GitHub hosting and native Stata `net install` packaging. The top level of this folder contains the core Stata package distribution files, while datasets, tests, build scripts, and multi-language theme implementations are organized into dedicated subdirectories:

```
scheme/
├── stata.toc                 # Stata package directory table of contents
├── wildcat.pkg               # Stata net install package manifest
├── scheme-wildcat.scheme     # Compiled standalone Stata scheme file
├── wildcat.sthlp             # Stata help documentation file
├── scheme-wildcat.sthlp      # Stata help alias for scheme-wildcat
├── colorpalette_wildcat.ado  # Native Wildcat palette for Ben Jann's colorpalette
├── colorpalette_nu.ado       # Backward-compatibility alias for colorpalette
├── color-*.style             # Standalone Stata color style definitions
├── FOR_AGENTS.md             # Dedicated guide and instructions for AI coding agents
├── data/                     # Bundled benchmark datasets for validation & testing
│   ├── auto.dta              # 1978 Automobile dataset
│   ├── trends.dta            # Multi-line sector growth dataset (2010–2022)
│   ├── lollipop.dta          # Deviation dataset for lollipop stem plot
│   ├── forest.dta            # Regression coefficient estimates (95% CI)
│   ├── dumbbell.dta          # Paired segment comparison dataset
│   ├── area.dta              # Energy portfolio composition dataset
│   ├── ribbon.dta            # Economic output projection with confidence intervals
│   └── pyramid.dta           # Quarterly variance tornado dataset
├── tests/                    # Comprehensive 16-graph validation test suites
│   ├── test_stata_plots.do   # Stata validation suite compiling 16 distinct plot types
│   ├── test_r_plots.R        # R validation suite compiling 16 matching ggplot2 plots
│   └── test_py_plots.py      # Python validation suite compiling 16 matching Matplotlib plots
├── stata/                    # Stata scheme generation source code
│   └── make_scheme.do        # Scheme generation & grstyle configuration script
├── r/                        # R theme implementation
│   ├── theme_wildcat.R       # Core ggplot2 theme, color vectors, palettes, and scales
│   └── theme_nu.R            # Backward-compatibility alias wrapper
├── py/                       # Python / Matplotlib theme implementation
│   ├── __init__.py           # Package entry point
│   ├── wildcat.mplstyle      # Standalone Matplotlib stylesheet
│   └── theme_wildcat.py      # Core module (set_theme, palettes, labs, legend_top)
├── output_checks/            # Shared output directory containing side-by-side validation PNGs
│   ├── stata_*.png           # 16 exported Stata test figures
│   ├── r_*.png               # 16 matching exported R ggplot2 test figures
│   └── py_*.png              # 16 matching exported Python Matplotlib test figures
├── latex/                    # Automated side-by-side comparison presentations
│   ├── update.ps1            # PowerShell script: compiles R vs. Stata presentation.pdf
│   ├── update.sh             # Bash script for Unix environments
│   ├── presentation.tex      # R vs. Stata Beamer presentation
│   ├── presentation.pdf      # Compiled R vs. Stata comparison presentation (16 slides)
│   ├── update_py_r.ps1       # PowerShell script: compiles Python vs. R presentation_py_r.pdf
│   ├── presentation_py_r.tex # Python vs. R Beamer presentation
│   └── presentation_py_r.pdf # Compiled Python vs. R comparison presentation (16 slides)
└── README.md                 # Scheme folder documentation and user guide
```

---

## Color Architecture

### 1. Northwestern University Official Brand Colors

The installed color style files (`color-*.style`) provide direct, native access to official Northwestern University brand colors across all Stata graph commands (e.g., `mcolor(nupurple)`, `lcolor(nudarkorange)`, `fcolor(nupurple20%50)`), matched identically in R and Python:

| Alias | RGB Values | Hex Code | Swatch / Description |
| :--- | :--- | :--- | :--- |
| `nupurple` | `78 42 132` | `#4E2A84` | Primary Northwestern Purple |
| `nupurple150` | `38 8 65` | `#260841` | Deep Purple (darkest accent) |
| `nupurple50` | `147 128 192` | `#9380C0` | Light Purple |
| `nupurple40` | `164 149 195` | `#A495C3` | Muted Purple Tint |
| `nupurple20` | `204 196 223` | `#CCC4DF` | Soft Purple Tint |
| `nubrightgreen` | `88 185 171` | `#58B9AB` | Bright Green |
| `nubrightteal` | `127 206 205` | `#7FCECD` | Bright Teal |
| `nubrightblue` | `80 145 205` | `#5091CD` | Bright Blue |
| `nubrightyellow` | `237 233 59` | `#EDE93B` | Bright Yellow |
| `nubrightorange` | `255 197 32` | `#FFC520` | Bright Orange |
| `nubrightred` | `239 85 63` | `#EF553F` | Bright Red |
| `nudarkgreen` | `0 134 86` | `#008656` | Dark Green |
| `nudarkteal` | `0 127 164` | `#007FA4` | Dark Teal |
| `nudarkblue` | `13 45 108` | `#0D2D6C` | Dark Blue |
| `nudarkyellow` | `217 200 38` | `#D9C826` | Dark Yellow |
| `nudarkorange` | `202 124 27` | `#CA7C1B` | Dark Orange |
| `nudarkred` | `216 88 32` | `#D85820` | Dark Red |
| `nurichblack` | `0 0 0` | `#000000` | Rich Black |

### 2. Wildcat Structural & Semantic Theme Colors

Non-NU structural elements (axes, canvas, gridlines, typography) are defined with the `wc_` prefix to avoid collisions while maintaining exact alignment with `ggplot2`:

| Color Name | RGB Values | Hex Code | Purpose / Semantic Role | Relationship to Built-in Stata Colors |
| :--- | :--- | :--- | :--- | :--- |
| `wc_bg` | `255 255 255` | `#FFFFFF` | Canvas and background fill | Identical to `white` / `gs16` (`255 255 255`) |
| `wc_axis` | `204 204 204` | `#CCCCCC` | Subtle X-axis baseline and tick marks | Closely approximates `gs13` (`208 208 208`) |
| `wc_grid` | `234 234 234` | `#EAEAEA` | Light horizontal gridlines | Closely approximates `dimgray` (`232 232 232`) and `gs15` (`240 240 240`) |
| `wc_title` | `34 34 34` | `#222222` | Dark charcoal for headings and axis titles | Closely approximates `gs2` (`32 32 32`) |
| `wc_body` | `102 102 102` | `#666666` | Muted gray for subtitles, captions, ticks, notes | Closely approximates `gs6` (`96 96 96`) |

> [!TIP]
> **Native Stata Color Referencing:**
> With the installed color style files, colors can be referenced directly in any graph command, including alpha/opacity modifiers:
> ```stata
> twoway (scatter mpg weight, mcolor(nupurple) mlcolor(nudarkorange)) ///
>        (line yhat weight, lcolor(nupurple%80) lwidth(medthick)), ///
>        yline(0, lcolor(wc_axis) lpattern(dash))
> ```

### 3. Default Categorical Series Sequence (Plot Order)

Mapped for maximum contrast and accessibility across discrete series (with Dark Orange #2):

1. `plot1`: `nupurple` (`#4E2A84`)
2. `plot2`: `nudarkorange` (`#CA7C1B`)
3. `plot3`: `nubrightblue` (`#5091CD`)
4. `plot4`: `nudarkgreen` (`#008656`)
5. `plot5`: `nubrightorange` (`#FFC520`)
6. `plot6`: `nubrightteal` (`#7FCECD`)
7. `plot7`: `nubrightred` (`#EF553F`)
8. `plot8`: `nudarkblue` (`#0D2D6C`)
9. `plot9`: `nudarkteal` (`#007FA4`)
10. `plot10`: `nubrightgreen` (`#58B9AB`)
11. `plot11`: `nudarkyellow` (`#D9C826`)
12. `plot12`: `nupurple50` (`#9380C0`)

---

## Typographic Hierarchy & Alignment

All three environments (**R `ggplot2`**, **Python `matplotlib`**, and **Stata**) share a synchronized typographic hierarchy based on **Arial** (`arial.ttf` / `arialbd.ttf`):

| UI / Graph Element | R (`ggplot2`) | Python (`matplotlib` / `theme_wildcat`) | Stata (`scheme-wildcat`) | Weight / Face | Points (at base=11) | Color (Hex / Alias) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Main Title** | `plot.title` (`rel(1.30)`) | `axes.titlesize` / `labs(title=...)` | `heading`, `title("{bf:...}")` | **Bold** (700) | ~14.3 pt | `#222222` (`wc_title`) |
| **Subtitle** | `plot.subtitle` (`rel(0.98)`) | `labs(subtitle=...)` | `subheading`, `size(small)` | Plain (400) | ~10.8 pt | `#666666` (`wc_body`) |
| **Axis Titles** | `axis.title.x`, `.y` (`rel(0.95)`) | `axes.labelsize` / `labs(x=..., y=...)` | `axis_title`, `size(small)` | Plain (400) | ~10.5 pt | `#222222` (`wc_title`) |
| **Axis Tick Numbers** | `axis.text.x`, `.y` (`rel(0.85)`) | `xtick.labelsize`, `ytick.labelsize` | `tick_label`, `size(small)` | Plain (400) | ~9.35 pt | `#666666` (`wc_body`) |
| **Legend Title** | `legend.title` (`rel(0.90)`) | `legend.title_fontsize` | `legend_title` | **Bold** (700) | ~9.9 pt | `#222222` (`wc_title`) |
| **Legend Items** | `legend.text` (`rel(0.85)`) | `legend.fontsize` / `legend_top()` | `key_label`, `size(small)` | Plain (400) | ~9.35 pt | `#666666` (`wc_body`) |
| **Facet Titles** | `strip.text.x`, `.y` (`rel(1.05)`) | Subplot title / suptitle | `bylabel`, `size(medium)` | **Bold** (700) | ~11.55 pt | `#222222` (`wc_title`) |
| **Footnotes / Caption**| `plot.caption` (`rel(0.82)`) | `labs(caption=...)` | `note` / `caption`, `size(2.4)` | Plain (400) | ~9.0 pt | `#666666` (`wc_body`) |

### Cross-Platform Alignment Highlights

- **Font Family**: Standardized to system sans-serif (`Arial`, with `Helvetica` and `DejaVu Sans` fallbacks).
- **Titles & Subtitles**: Aligned flush left above the plot canvas across all three tools, using bold dark charcoal for titles and plain muted gray for subtitles.
- **Top-Mounted Legends**: Positioned horizontally above the plot area flush with the left boundary (`11 o'clock` in Stata, `legend.position = "top"` in R, `legend_top()` in Python).
- **Subtle Scales**: Y-axis vertical lines and tick marks are eliminated in all three environments, relying solely on thin horizontal gridlines (`#EAEAEA`) and light X-axis baselines (`#CCCCCC`).

---

## Core Visual Specifications

1. **Axes & Grids:**
   - **Horizontal Gridlines**: Enabled by default along the Y-axis using `wc_grid` (`#EAEAEA` / `234 234 234`).
   - **Vertical Gridlines**: Disabled by default along the X-axis.
   - **X-Axis Baseline & Ticks**: Subtle baseline and ticks rendered in `wc_axis` (`#CCCCCC` / `204 204 204`).
   - **Y-Axis Baseline & Ticks**: Completely eliminated (zero line, zero ticks) to match modern minimal aesthetics.

2. **Legends:**
   - Positioned at top-left (`11 o'clock` in Stata, top-left horizontal in R and Python), spanning horizontally to flush with the left plot boundary.
   - Square legend symbols with tight element padding matching R `ggplot2`.

3. **Marker Sizing:**
   - Default marker symbol set to filled circles (`circle`) with standard sizing (~1.04% of graph height), matching `ggplot2` `geom_point()` defaults without external dependencies.

4. **Facet Strips (By-graphs):**
   - Clean, transparent banner styling without shaded gray boxes, dark charcoal labels (`wc_title`), and embedded directly within the themes.

5. **Bar & Box Proportions:**
   - Proportional bar gap (`bar_gap 100pct` in Stata) and box gap (`box_gap 75pct`) yielding refined, balanced widths matching `ggplot2` defaults without per-graph overrides.

---

## Customizing Themes / Building Your Own Brand Theme

> [!TIP]
> For automated editing or programmatic reconfiguration by AI coding agents, refer to [**`FOR_AGENTS.md`**](FOR_AGENTS.md) which details exact regex patterns and code blocks for theme customization.

### 1. Customizing the Stata Scheme

The repository includes a modular generator script, [`stata/make_scheme.do`](stata/make_scheme.do), allowing anyone to easily build their own custom Stata scheme (e.g., for another university, company, research lab, or personal preference).

At the top of [`stata/make_scheme.do`](stata/make_scheme.do), a dedicated **User Configuration & Customization Section** allows quick modifications:

```stata
* ------------------------------------------------------------------------------
* USER CONFIGURATION & CUSTOMIZATION SECTION
* ------------------------------------------------------------------------------
local scheme_name       "wildcat"        // Scheme identifier: compiles scheme-`scheme_name'.scheme
local scheme_title      "Wildcat"        // Descriptive title for display
local make_color_styles 1                // 1 = write color-*.style files to root, 0 = skip

* Un-comment this block and swap out names to define your own custom colors:
/* 
local custom_color_1 "0 0 0"            // Swap out custom name and RGB values (e.g., "myblue" "0 51 102")
local custom_colors custom_color_1      // Triggers color style file generation (color-*.style) in Section 5
*/
```

#### Step-by-Step Stata Customization:
1. **Change the Scheme Name:** Change `local scheme_name "wildcat"` to your preferred identifier (e.g., `local scheme_name "mytheme"`).
2. **Add Custom Colors:** Un-comment the custom colors block and define your RGB values:
   ```stata
   local mycrimson   "165 28 48"
   local mygold      "255 199 44"
   local custom_colors mycrimson mygold
   ```
3. **Reorder the Categorical Palette:** Update `color1` through `color12` with your custom color locals.
4. **Compile:** Run `do stata/make_scheme.do` in Stata. The compiled `scheme-<scheme_name>.scheme` and all corresponding `color-*.style` files will be generated immediately.

---

### 2. Packaging & Local Installation in Stata

To install your custom scheme locally via Stata's `net install`:

```stata
* 1. Tell Stata to read from your local folder:
net from "C:/path/to/mytheme_pkg"

* 2. Inspect and install:
net describe mytheme
net install mytheme, replace

* 3. Verify and activate:
set scheme mytheme, permanently
```

Alternatively, copy `scheme-<scheme_name>.scheme` and `color-*.style` files directly into your Stata `PERSONAL` directory (`sysdir` in Stata resolves the path).

---

### 3. Customizing the R (`ggplot2`) Theme

In `r/theme_wildcat.R`:
1. Add custom hex colors into `wildcat_colors`:
   ```r
   wildcat_colors <- c(
     ...,
     mycrimson = "#A51C30",
     mygold = "#FFC72C"
   )
   ```
2. Update `wildcat_palettes$default` with your custom color vector.
3. Call `theme_wildcat(base_size = 12)` or adjust element settings using standard `ggplot2` syntax.

---

### 4. Customizing the Python (`matplotlib`) Theme

In `py/theme_wildcat.py`:
1. Add custom hex colors into `wildcat_colors`:
   ```python
   wildcat_colors["mycrimson"] = "#A51C30"
   wildcat_colors["mygold"] = "#FFC72C"
   ```
2. Adjust `wildcat_palettes["default"]` or register custom palettes.
3. Update figure margins, font sizes, or gridline defaults in `get_wildcat_rcparams()` or at runtime via `set_theme(base_size=12.0)`.

---

## Verification & Validation Suite

Run the full validation suite across all 16 supported chart types:

- **Stata**: Run `tests/test_stata_plots.do`
- **R**: Run `Rscript tests/test_r_plots.R`
- **Python**: Run `python tests/test_py_plots.py`
- **Slide Deck Compilations**:
  - **R vs. Stata Comparison**: Run `powershell -ExecutionPolicy Bypass -File latex/update.ps1` to compile `latex/presentation.pdf`.
  - **Python vs. R Comparison**: Run `powershell -ExecutionPolicy Bypass -File latex/update_py_r.ps1` to compile `latex/presentation_py_r.pdf`.

---

## Links & Further Reading

- [Wildcat Parent Repository](https://github.com/aarondwolf/wildcat) — Main repository for the Northwestern Beamer presentation theme.
- [AI Agent Guide (`FOR_AGENTS.md`)](FOR_AGENTS.md) — Targeted instructions for AI coding agents to automate theme usage, downloads, and custom rebuilds.
- [Northwestern University Brand Guidelines](https://www.northwestern.edu/brand/visual-identity/) — Official brand colors, typography, and visual identity standards.
