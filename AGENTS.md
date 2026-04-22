# Wildcat Beamer Theme

A modern, customizable Beamer presentation theme based on Northwestern University branding.

## Project Overview

This is a LaTeX Beamer theme (`\usetheme{wildcat}`) that implements Northwestern University's visual identity — purple color palette, facet geometric background pattern, and official fonts (Campton, Akkurat Pro). It is **not** an official Northwestern template.

## Repository Structure

```
source/
  beamerthemewildcat.sty          # Main theme loader; handles pattern=, color=, font= options
  beamercolorthemewildcat.sty     # Color definitions (wcprimary, nu* colors, blocks)
  beamerinnerthemewildcat.sty     # Background patterns (12 built-in), title page, section pages,
                                  #   tcolorbox blocks (tblock/talert/texample/tpatternbox), standout
  beamerouterthemewildcat.sty     # Frame title and footer (page numbers)
  beamerfontthemewildcat.sty      # Single consolidated font theme; branches on font= option:
                                  #   (default) Fira Sans — no files needed, works on Overleaf
                                  #   poppins   — Poppins + IBM Plex Sans (TTF files from fonts/)
                                  #   nu        — Campton + Akkurat Pro (OTF files from fonts/)
                                  #   installed — Campton + Akkurat Pro from OS font registry
  fonts/
    Campton/                      # Campton OTF files (Medium, Light, etc.) — for font=nu
    Akkurat/                      # Akkurat Pro OTF files — for font=nu
    Poppins/                      # Poppins TTF files — for font=poppins
    IBM_Plex_Sans/static/         # IBM Plex Sans TTF files — for font=poppins
  bg-gallery/
    bg-template.tex               # Contribution template with instructions and a plain-fill example
    bg-voronoi.tex                # Voronoi diagram pattern (15 seeds, computed via scipy+shapely)
  wildcat-demo.tex                # Comprehensive demo/documentation presentation
  wildcat-demo.pdf                # Compiled demo
  logo-northwestern.pdf           # Northwestern "N" logo
  graphs/                         # Example graphs (R, Python, Stata) for demo slides
Northwestern Branding/            # Original brand assets (fonts, AI files)
```

## Compilation

**Must use XeLaTeX or LuaLaTeX** — PDFLaTeX will fail due to `fontspec` usage.

```bash
xelatex wildcat-demo.tex
```

## Key Design Concepts

### Color System
- `wcprimary` — main theme color (default: Northwestern purple `RGB{78,42,132}`)
- `wcprimary10`–`wcprimary40` — lighter shades (used in block bodies, section backgrounds)
- `wcprimary110`–`wcprimary140` — darker shades (used in facet pattern segments)
- `wcalerted` — alert color (default: nudarkorange)
- `wcexample` — example color (default: nudarkgreen)
- All `nu*` colors (nupurple, nubrightgreen, etc.) are defined for user reference but not used internally

### Background Pattern
12 built-in patterns are selectable via `pattern=` theme option. Selected via:
```latex
\usetheme[pattern=triangle]{wildcat}
```
Available: `facet` (default), `facetrand`, `triangle`, `triangleiso`, `trianglemesh`, `squares`, `circles`, `hexraise`, `hexrand`, `network`, `quilt`, `plain`.

The active pattern is stored in three commands in `beamerinnerthemewildcat.sty`:
- `\bgpattern` — full-color version (title page, standout frames, tblock titles)
- `\bgpatternlight` — faded version (section pages)
- `\bgpatternblock{color}` — color-parameterized version (talert, texample, tpatternbox)

The background is only drawn on page 1 (title) and section pages; all other slides have a plain white background.

Custom patterns can be loaded from `bg-gallery/` via `\input{bg-gallery/bg-voronoi}` in the preamble after `\usetheme`. Use `\input{}` not `\include{}` — patterns must be set in the preamble. See `bg-gallery/bg-template.tex` for the contribution template.

### Custom Block Environments (tcolorbox)
- `tblock{Title}` — primary color pattern block
- `talert{Title}` — alert color pattern block
- `texample{Title}` — example color pattern block
- `tpatternbox[color]{Title}` — custom color pattern block (optional color arg, default wcprimary)
- `tfacetbox` — backward-compatibility alias for `tpatternbox` (defined via `\NewDocumentEnvironment`)

Standard Beamer `block`, `alertblock`, `exampleblock` also work.

### Special Frames
- `\standout{Text}` — full-pattern background slide with centered white text, no title/footer
- `[plain]` option on `\begin{frame}` — fully blank white frame

## Customization

All three main options can be combined in a single `\usetheme` call:
```latex
\usetheme[pattern=triangle, color=nudarkblue, font=poppins]{wildcat}
```

**Color** — pass any named color; all `wcprimary` shades are auto-generated:
```latex
\usetheme[color=nudarkblue]{wildcat}
```
For precise per-shade control, redefine `wcprimary10`–`40` and `wcprimary110`–`140` manually after `\usetheme`.

**Font** — four options, all controlled via the single `beamerfontthemewildcat.sty` file:
```latex
\usetheme{wildcat}                    % default: Fira Sans (no files needed)
\usetheme[font=poppins]{wildcat}      % Poppins + IBM Plex Sans (TTF files in fonts/)
\usetheme[font=nu]{wildcat}           % Campton + Akkurat Pro (OTF files in fonts/)
\usetheme[font=installed]{wildcat}    % Campton + Akkurat Pro from OS font registry
```

**Background pattern** — use a built-in via `pattern=`, or load a custom one from `bg-gallery/`:
```latex
\input{bg-gallery/bg-voronoi}   % after \usetheme; use \input not \include
```

**Section/subsection pages** — controlled via `sectionpage=` and `subsectionpage=`:
```latex
\usetheme[sectionpage=none]{wildcat}        % disable section divider pages
\usetheme[subsectionpage=on]{wildcat}       % enable subsection divider pages (default: none)
```
Section pages show the section number (large) and section title on a white left-2/3 panel against the bgpattern on the right 1/3. Subsection pages additionally show the subsection title in italic below.

**Slide numbering** — controlled via `numbering=`:
```latex
\usetheme[numbering=fraction]{wildcat}  % default: i/N excluding title page
\usetheme[numbering=number]{wildcat}    % slide number only
\usetheme[numbering=none]{wildcat}      % no slide numbering
```

## Overleaf

- Template available on Overleaf (see README for link)
- The default font (Fira Sans) works on Overleaf out of the box — no separate font theme needed
- The `font=poppins` option also works on Overleaf if the TTF files are uploaded to the project
- The `font=nu` / `font=installed` options require proprietary fonts not available on Overleaf
- The Northwestern logo file must be uploaded separately if needed
- The footer in `beamerouterthemewildcat.sty` uses `ht=-2.5ex` (a negative height). This is a deliberate workaround: without it, the page number renders halfway off the bottom of the slide on Overleaf. The root cause is unknown but the fix is confirmed. Do not change this value.

## File Conventions

- All `.sty` files are in `source/` and must be in the same directory as the `.tex` file (or on the LaTeX path)
- Font OTF files are expected at `fonts/Campton/` and `fonts/Akkurat/` relative to the `.tex` file
- Page numbering starts at 1 but displays as `(n-1)/(total-1)` to exclude the title page from the count

## Planned Features

- Light color theme variant
