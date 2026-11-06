# Wildcat Graph Theme System (Stata, R ggplot2 & Python Matplotlib)

A unified, publication-grade graph theme and styling repository featuring official **Northwestern University** branding. This system provides synchronized styling implementations for **Stata** (`scheme-wildcat`), **R** (`theme_wildcat`), and **Python** (`theme_wildcat` / `wildcat.mplstyle`), ensuring that figures produced across all three environments share an identical visual language, typographic hierarchy, and brand-compliant color palette.

---

## Quick Installation & Setup

### Stata Installation via `net install`

Install the complete scheme, custom marker styles, and official Northwestern color style files directly from GitHub into your personal/plus ADO directory:

```stata
* Install scheme, styles, and color definitions
net from "https://github.com/aarondwolf/wildcat/tree/main/scheme"
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

## Repository Structure

The repository is structured for seamless GitHub hosting and native Stata `net install` packaging. The root directory contains only the core package distribution files, while datasets, tests, build scripts, and documentation are organized into dedicated subdirectories:

```
├── stata.toc                 # Stata package directory table of contents
├── wildcat.pkg               # Stata net install package manifest
├── scheme-wildcat.scheme     # Compiled standalone Stata scheme file
├── wildcat.sthlp             # Stata help documentation file
├── scheme-wildcat.sthlp      # Stata help alias for scheme-wildcat
├── colorpalette_wildcat.ado  # Native Wildcat palette for Ben Jann's colorpalette
├── colorpalette_nu.ado       # Backward-compatibility alias for colorpalette
├── color-*.style             # Standalone Stata color style definitions
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
└── README.md                 # Complete documentation and user guide
```

---

## Color Architecture

### 1. Northwestern University Official Brand Colors

The installed color style files (`color-*.style`) provide direct, native access to official Northwestern University brand colors across all Stata graph commands (e.g., `mcolor(nupurple)`, `lcolor(nudarkorange)`, `fcolor(nupurple20%50)`):

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

Both environments share an aligned typographic hierarchy based on **Arial** (`arial.ttf` / `arialbd.ttf`):

| UI / Graph Element | ggplot2 Element Name | Font Family | Weight / Face | Relative Size | Points (at base=11) | Color (Hex / RGB) | Stata Scheme Equivalent |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Main Title** | `plot.title` | `Arial` (sans) | **Bold** (700) | `rel(1.30)` | ~14.3 pt | `#222222` | `heading` (`wc_title`), `title("{bf:...}")` |
| **Subtitle** | `plot.subtitle` | `Arial` (sans) | Plain (400) | `rel(0.98)` | ~10.8 pt | `#666666` | `subheading` (`wc_body`), `size(small)` |
| **Axis Titles** | `axis.title` (`.x`, `.y`) | `Arial` (sans) | Plain (400) | `rel(0.95)` | ~10.5 pt | `#222222` | `axis_title` (`wc_title`), `size(small)` |
| **Axis Tick Numbers** | `axis.text` (`.x`, `.y`) | `Arial` (sans) | Plain (400) | `rel(0.85)` | ~9.35 pt | `#666666` | `tick_label` (`wc_body`), `size(small)` |
| **Legend Title** | `legend.title` | `Arial` (sans) | **Bold** (700) | `rel(0.90)` | ~9.9 pt | `#222222` | `legend_title` (`wc_title`) |
| **Legend Items** | `legend.text` | `Arial` (sans) | Plain (400) | `rel(0.85)` | ~9.35 pt | `#666666` | `key_label` (`wc_body`), `size(small)` |
| **Facet Titles** | `strip.text` (`.x`, `.y`) | `Arial` (sans) | **Bold** (700) | `rel(1.05)` | ~11.55 pt | `#222222` | `bylabel` (`wc_title`), `size(medium)` |
| **Footnotes / Note** | `plot.caption` | `Arial` (sans) | Plain (400) | `rel(0.82)` | ~9.0 pt | `#666666` | `note` / `caption` (`wc_body`), `size(2.4)` |

---

## Core Visual Specifications

1. **Axes & Grids:**
   - **Horizontal Gridlines**: Enabled by default along the Y-axis using `wc_grid` (`#EAEAEA` / `234 234 234`).
   - **Vertical Gridlines**: Disabled by default along the X-axis.
   - **X-Axis Baseline & Ticks**: Subtle baseline and ticks rendered in `wc_axis` (`#CCCCCC` / `204 204 204`).
   - **Y-Axis Baseline & Ticks**: Completely eliminated (zero line, zero ticks) to match modern minimal aesthetics.

2. **Legends:**
   - Positioned at top-left (`11 o'clock`), spanning horizontally to flush with the left plot boundary.
   - Square legend symbols (`medsmall`) with tight element padding matching R `ggplot2`.

3. **Marker Sizing:**
   - Default marker symbol set to filled circles (`circle`) with standard built-in `small` sizing (~1.04% of graph height), approximating `ggplot2` `geom_point()` defaults without external style dependencies.

4. **Facet Strips (By-graphs):**
   - Clean, transparent banner styling without shaded gray boxes (`areastyle by_title none`, `bylabel_outline none`), dark charcoal labels (`wc_title`), and embedded directly within `scheme-wildcat.scheme`.

5. **Bar & Box Proportions:**
   - Proportional bar gap (`bar_gap 100pct`) and box gap (`box_gap 75pct`) yielding refined, balanced bar widths without per-graph overrides.

---

## Customizing the Scheme / Building Your Own Theme

The repository includes a modular generator script, [`stata/make_scheme.do`](stata/make_scheme.do), allowing anyone to easily build their own custom Stata scheme (e.g., for another university, company, research lab, or personal preference).

At the very top of [`stata/make_scheme.do`](stata/make_scheme.do), a dedicated **User Configuration & Customization Section** allows you to make quick modifications:

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

### 1. Making a Lightly Touched Custom Scheme:

1. **Change the Scheme Name:**
   - Change `local scheme_name "wildcat"` to your preferred identifier (e.g., `local scheme_name "mytheme"`).
   - Running the script will compile `scheme-mytheme.scheme` in the root directory. You can then use `set scheme mytheme` in Stata!

2. **Add Custom Colors:**
   - In lines 30–33 of `stata/make_scheme.do`, un-comment the custom colors block and define your RGB values:
     ```stata
     local mycrimson   "165 28 48"
     local mygold      "255 199 44"
     local custom_colors mycrimson mygold
     ```
   - When `make_color_styles` is set to `1`, `make_scheme.do` automatically creates `color-mycrimson.style` and `color-mygold.style`. This allows direct referencing in any graph command, such as `mcolor(mycrimson)` or `lcolor(mygold%80)`.

3. **Reorder the Categorical Series Palette:**
   - Modify the `color1` through `color12` assignments to prioritize your new custom colors for grouped charts:
     ```stata
     local color1 "`mycrimson'"
     local color2 "`mygold'"
     local color3 "`nubrightblue'"
     ```

4. **Customize Canvas and Structural Elements:**
   - In Section 2 of `make_scheme.do`, adjust any structural theme elements:
     - `wc_bg`: Background canvas color (default pure white `255 255 255`).
     - `wc_grid`: Horizontal gridlines (default subtle gray `234 234 234`).
     - `wc_axis`: Baseline axis line and ticks (default `#CCCCCC` / `204 204 204`).
     - `wc_title`: Headings, axis titles, and facet strip text (default `#222222` / `34 34 34`).
     - `wc_body`: Subtitles, captions, tick labels, and footnotes (default `#666666` / `102 102 102`).

5. **Compile Your New Scheme:**
   - Open Stata and execute:
     ```stata
     do stata/make_scheme.do
     ```
   - The compiled `scheme-<scheme_name>.scheme` and all corresponding `color-*.style` files are immediately generated and ready to use.

---

### 4. Customizing the Python Theme

To customize colors, palettes, or default properties in Python:
1. In `py/theme_wildcat.py`, add custom hex colors into `wildcat_colors`:
   ```python
   wildcat_colors["mycrimson"] = "#A51C30"
   wildcat_colors["mygold"] = "#FFC72C"
   ```
2. Adjust `wildcat_palettes["default"]` or add custom named palettes to `wildcat_palettes`.
3. To alter figure margins, font sizes, or grid styles, update the parameters in `get_wildcat_rcparams()` or pass them at runtime via `set_theme(base_size=12.0)`.

---

### 5. Customizing the R `ggplot2` Theme

To customize colors, palettes, or default properties in R:
1. In `r/theme_wildcat.R`, add custom hex colors into `wildcat_colors`:
   ```r
   wildcat_colors <- c(
     ...,
     mycrimson = "#A51C30",
     mygold = "#FFC72C"
   )
   ```
2. Update `wildcat_palettes$default` with your custom color vector.
3. Call `theme_wildcat(base_size = 12)` or customize `theme()` elements as needed in standard `ggplot2` syntax.

---

To bundle your custom scheme so that it can be shared with colleagues or archived as a standalone package:

1. Create a dedicated folder (e.g., `mytheme_pkg/`).
2. Copy the following files into that folder:
   - `scheme-<scheme_name>.scheme` (the compiled scheme file)
   - Any custom `color-*.style` files generated by `make_scheme.do`
   - (Optional) A help file `scheme-<scheme_name>.sthlp`
3. Add a minimal **`stata.toc`** file:
   ```text
   v 3
   d 'MYTHEME': Custom publication-grade Stata graph scheme
   p mytheme
   ```
4. Add a minimal package manifest file **`<scheme_name>.pkg`** (e.g., `mytheme.pkg`):
   ```text
   v 3
   d 'MYTHEME': Custom publication-grade Stata graph scheme
   d Distribution-Date: 20261106
   f scheme-mytheme.scheme
   f color-mycrimson.style
   f color-mygold.style
   ```

---

### 3. Installing Your Scheme Locally in Stata via `net install`

Stata's `net` package manager supports installing packages directly from a local directory path:

```stata
* 1. Tell Stata to read from your local folder (use forward slashes or double quotes):
net from "C:/path/to/mytheme_pkg"

* 2. Inspect the package contents:
net describe mytheme

* 3. Install the package into your personal Stata ADO directory:
net install mytheme, replace

* 4. Verify and activate the scheme:
which scheme-mytheme.scheme
set scheme mytheme, permanently
```

#### Why use `net install` from local?
- **Automatic Organization:** Stata automatically places the scheme file into `ado/plus/s/`, color styles into `ado/plus/c/`, and help files into `ado/plus/m/`.
- **Global Availability:** The scheme and custom colors become immediately accessible from *any* working directory on your computer without needing to copy files between project folders.
- **Package Management:** The package is tracked by Stata (`ado dir`), allowing clean updates (`net install mytheme, replace`) or uninstallation (`ado uninstall mytheme`).

> [!TIP]
> **Quick Manual Alternative:**
> If you do not wish to create `.pkg` and `.toc` files, you can simply copy `scheme-<scheme_name>.scheme` and any `color-*.style` files directly into your Stata `PERSONAL` directory (type `sysdir` in Stata to find the exact path, typically `C:\ado\personal\` on Windows or `~/Library/Application Support/Stata/personal/` on macOS). Stata will immediately recognize the scheme.

---

## Verification & Validation Suite

Run the full validation suite across all 16 supported chart types:

- **Stata**: Run `tests/test_stata_plots.do`
- **R**: Run `Rscript tests/test_r_plots.R`
- **Python**: Run `python tests/test_py_plots.py`
- **Slide Deck Compilations**:
  - **R vs. Stata Comparison**: Run `powershell -ExecutionPolicy Bypass -File latex/update.ps1` to compile `latex/presentation.pdf`.
  - **Python vs. R Comparison**: Run `powershell -ExecutionPolicy Bypass -File latex/update_py_r.ps1` to compile `latex/presentation_py_r.pdf`.
