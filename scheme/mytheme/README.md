# MyTheme: Custom Stata Graph Scheme Template

A clean, customizable starter template to build your own publication-grade Stata graph scheme synchronized with R's `ggplot2` (`theme_minimal()`).

## Quick Start (3 Steps)

### 1. Customize Colors (Optional)
Open `make_scheme_mytheme.do` and replace the boilerplate RGB values under `customcolor1` through `customcolor8` with your organization's brand palette or personal preferences. You can also change `scheme_name` (e.g., from `"mytheme"` to `"hawkeye"` or `"myuniv"`).

### 2. Generate the Scheme & Color Styles
Open Stata, navigate to this directory (or simply open the file in Stata), and run:

```stata
do make_scheme_mytheme.do
```

This compiles:
- `scheme-mytheme.scheme` (the complete graph scheme)
- `color-customcolor1.style` through `color-customcolor8.style` (named color styles)
- `color-wc_*.style` (clean canvas, text, axis, and grid structural colors)

All files are created directly in this folder.

### 3. Install Locally in Stata
Install the scheme into your local Stata environment using Stata's built-in package manager:

```stata
net from "`c(pwd)'"
net install mytheme, replace
set scheme mytheme, permanently
```

*(Replace `` `c(pwd)' `` with the full path to this directory if Stata's working directory is set elsewhere).*

## Testing Your Scheme

```stata
sysuse auto, clear
set scheme mytheme
twoway (lfitci mpg weight) (scatter mpg weight), title("Fuel Efficiency vs. Weight")
```

You can also use your named colors directly in any graph:
```stata
scatter mpg weight, mcolor(customcolor1)
```

## Included Template Files

- `make_scheme_mytheme.do` — Scheme compilation script (uses `grstyle`)
- `stata.toc` — Package distribution table of contents
- `mytheme.pkg` — Package manifest for `net install`
- `mytheme.sthlp` & `scheme-mytheme.sthlp` — Stata help documentation
- `mytheme.zip` — Compressed bundle of this template for distribution
