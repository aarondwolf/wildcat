# Agent Guide: Wildcat Theme System (Stata, R, Python)

> **Repository context:**
> The upstream repository is [`https://github.com/aarondwolf/wildcat`](https://github.com/aarondwolf/wildcat).
> The scheme and plotting assets live inside the `scheme/` subdirectory of that repo:
> `https://github.com/aarondwolf/wildcat/tree/main/scheme`
>
> All paths in this document are described relative to that `scheme/` directory.

This guide provides instructions for AI coding agents to:
1. **Download and install** the theme files across Stata, R, and Python.
2. **Reference and use** them in user scripts and automation workflows.
3. **Customize colors, palettes, and theme names** programmatically across all three environments.
4. **Maintain visual parity** so graphs across Stata, R, and Python match closely.

---

## 1. Quick Summary of Assets by Language

| Language | Core Assets | Styling Model | Source of Truth / Reference |
| :--- | :--- | :--- | :--- |
| **Stata** | `scheme-wildcat.scheme`, `color-*.style`, `wildcat.pkg`, `stata/make_scheme.do` | Stata Graph Scheme & Style definitions | Anchored to R `ggplot2` |
| **R** | `r/theme_wildcat.R`, `r/theme_nu.R` | `ggplot2` theme functions & discrete scales | **Primary visual source of truth** |
| **Python** | `py/theme_wildcat.py`, `py/wildcat.mplstyle`, `py/__init__.py` | Matplotlib `rcParams`, cycler, helper functions | Anchored to R `ggplot2` |

---

## 2. Stata Workflow

### A. Downloading & Installing
When working in an agent environment with Stata available:

- **From GitHub (Standard):**
  ```stata
  net from "https://github.com/aarondwolf/wildcat/tree/main/scheme"
  net describe wildcat
  net install wildcat, replace
  set scheme wildcat, permanently
  ```

- **From Local Repository Clone:**
  If the repository is already cloned locally at `path/to/scheme`:
  ```stata
  net from "path/to/scheme"
  net describe wildcat
  net install wildcat, replace
  set scheme wildcat, permanently
  ```

- **Direct Personal ADO Fallback (if `net` cannot write):**
  Copy `scheme-wildcat.scheme` into `PERSONAL/s/` and all `color-*.style` files into `PERSONAL/c/` (use `sysdir` in Stata to resolve `PERSONAL`).

### B. Referencing in Stata Scripts
Once installed:
```stata
* Apply scheme globally or per graph:
set scheme wildcat

* Use native Northwestern brand colors directly in graph commands:
twoway (scatter mpg weight, mcolor(nupurple) mlcolor(nudarkorange)) ///
       (lfit mpg weight, lcolor(nupurple%80) lwidth(medthick)), ///
       title("{bf:Mileage vs. Weight}", size(medium) color(wc_title)) ///
       subtitle("Northwestern branding", size(small) color(wc_body)) ///
       note("Source: 1978 Automobile Data", size(vsmall) color(wc_body))
```

### C. Customizing Colors & Scheme Name in Stata
Do not manually edit `scheme-wildcat.scheme` directly; edit and execute [`stata/make_scheme.do`](stata/make_scheme.do):

1. **Change Theme Name:**
   In [`stata/make_scheme.do`](stata/make_scheme.do), change:
   ```stata
   local scheme_name   "custom_name"     // Will generate scheme-custom_name.scheme
   local scheme_title  "Custom Theme"
   ```
2. **Add Custom Brand Colors:**
   Un-comment and define custom RGB strings:
   ```stata
   local myblue   "0 51 102"
   local mygold   "255 199 44"
   local custom_colors myblue mygold
   ```
3. **Change Discrete Plot Sequence:**
   Update `local color1 "`myblue'"`, `local color2 "`mygold'"`, etc.
4. **Compile:**
   Execute `do stata/make_scheme.do`. It regenerates `scheme-<name>.scheme` and all corresponding `color-<name>.style` files.

---

## 3. R Workflow (`ggplot2`)

### A. Downloading & Referencing
R packages are often invoked on systems without Git cloning. Agents can load `theme_wildcat.R` directly via URL or local path:

- **Source from Local Repo:**
  ```r
  source("r/theme_wildcat.R")
  ```

- **Source Directly from GitHub (no local clone needed):**
  ```r
  # Raw URL to GitHub scheme folder
  source("https://raw.githubusercontent.com/aarondwolf/wildcat/main/scheme/r/theme_wildcat.R")
  ```

### B. Standard Usage in R Scripts
```r
library(ggplot2)
source("r/theme_wildcat.R")

ggplot(df, aes(x = weight, y = mpg, color = foreign)) +
  geom_point(size = 2.2) +
  scale_color_wildcat() +     # Or scale_color_nu()
  theme_wildcat() +           # Or theme_nu()
  labs(
    title = "Automobile Weight vs. Fuel Efficiency",
    subtitle = "Northwestern branding",
    x = "Vehicle Weight (lbs.)",
    y = "Mileage (mpg)",
    caption = "Source: 1978 Automobile Data"
  )
```

For continuous fills/colors:
- `scale_fill_wildcat_c(palette = "purple")`
- `scale_fill_wildcat_c(palette = "diverging")`

### C. Customizing Colors & Palettes in R
In [`r/theme_wildcat.R`](r/theme_wildcat.R):
1. **Add Custom Colors:** Add hex codes to `wildcat_colors`:
   ```r
   wildcat_colors <- c(
     ...,
     myblue = "#003366",
     mygold = "#FFC72C"
   )
   ```
2. **Update Discrete Palette:** Modify `wildcat_palettes$default` with your custom color keys.
3. **Custom Theme Name:** To rename the theme function, create an alias:
   ```r
   theme_mycustom <- theme_wildcat
   scale_color_mycustom <- scale_color_wildcat
   ```

---

## 4. Python Workflow (`matplotlib`)

### A. Downloading & Referencing
Agents can download or import `theme_wildcat.py` and `wildcat.mplstyle`:

- **From Local Repo / Workspace:**
  Ensure the directory containing `py` is on `PYTHONPATH` or import directly:
  ```python
  import sys
  from pathlib import Path
  # Add scheme folder to path if needed:
  sys.path.append(str(Path("path/to/scheme")))

  from py.theme_wildcat import set_theme, wildcat_colors, wildcat_palettes, labs, legend_top
  ```

- **Direct Download from GitHub (via `urllib` or `requests`):**
  If working in a headless container or scratch folder:
  ```python
  import urllib.request
  base_url = "https://raw.githubusercontent.com/aarondwolf/wildcat/main/scheme/py/"
  urllib.request.urlretrieve(base_url + "theme_wildcat.py", "theme_wildcat.py")
  urllib.request.urlretrieve(base_url + "wildcat.mplstyle", "wildcat.mplstyle")
  ```

### B. Standard Usage in Python Scripts
```python
import matplotlib.pyplot as plt
from py.theme_wildcat import set_theme, wildcat_colors, labs, legend_top

# 1. Apply theme globally
set_theme()

# 2. Build plot
fig, ax = plt.subplots(figsize=(8.0, 5.0))
for group_name, grp in df.groupby("foreign"):
    ax.scatter(grp["weight"], grp["mpg"], label=group_name, s=28)

# 3. Add ggplot2-style titles & subtitle
labs(
    ax,
    title="Automobile Weight vs. Fuel Efficiency",
    subtitle="Northwestern branding",
    x="Vehicle Weight (lbs.)",
    y="Mileage (mpg)",
    caption="Source: 1978 Automobile Data"
)

# 4. Add top legend aligned to ggplot2 position
legend_top(ax, ncol=2)

plt.savefig("figure.png", dpi=300)
```

### C. Customizing Colors & Palettes in Python
In [`py/theme_wildcat.py`](py/theme_wildcat.py):
1. **Add Custom Colors:** Add keys to `wildcat_colors`:
   ```python
   wildcat_colors["myblue"] = "#003366"
   wildcat_colors["mygold"] = "#FFC72C"
   ```
2. **Update Discrete Palette:** Modify `wildcat_palettes["default"]` list.
3. **Custom Theme Name:** Create alias functions:
   ```python
   theme_mycustom = set_theme
   ```

---

## 5. Visual Consistency Guardrails for Agents

When generating plots or modifying themes, maintain these parity rules unless users request to change them specifically:

1. **Aspect Ratio & Canvas Geometry:**
   - Standard output canvas is $8.0 \times 5.0$ inches (ratio 1.60).
   - In Python, margins are configured in `get_wildcat_rcparams()`:
     `left=0.075`, `right=0.972`, `bottom=0.177`, `top=0.810`.
2. **Legend Positioning:**
   - Standard top legend in R sits at row **236 px** ($y = 0.840$ in figure coordinates at $1500 \times 2400\text{ px}$).
   - In Python, always use `legend_top(ax)` or `bbox_to_anchor=(x0, 0.840)`, `bbox_transform=fig.transFigure`, `loc="center left"` to avoid shifting plot axes downward.
3. **Typography & Hierarchy:**
   - Font family: Arial (sans-serif).
   - Main title: Bold, charcoal `#222222`, 14.3 pt, flush left.
   - Subtitle: Regular, muted gray `#666666`, ~10.8 pt, placed below title.
   - Gridlines: Horizontal only, `#EAEAEA`. Y-axis line and ticks are hidden; X-axis has subtle `#CCCCCC` baseline.
