# wildcat
A modern, highly customizable Beamer theme.

## Overview
This Beamer theme uses branding guidelines (colors, fonts, and logos) from [Northwestern University](https://www.northwestern.edu/brand/visual-identity/). The design mimics Northwestern's facets Zoom backgrounds, and the style files build on the amazing Stack Exchange answer by [Claudio Fiandrino](https://tex.stackexchange.com/questions/146529/design-a-custom-beamer-theme-from-scratch). This is not an official Northwestern-approved Beamer template.

## Quick Start
The easiest way to get started is to download [presentation.zip](https://github.com/aarondwolf/wildcat/blob/main/presentation.zip) and unzip it. It contains all the `.sty` files and a `main.tex` starter file ready to compile with XeLaTeX.

Alternatively, place all `.sty` files in the same directory as your `.tex` file and add to your preamble:

```latex
\usetheme{wildcat}
```

Requires **XeLaTeX** or **LuaLaTeX** — PDFLaTeX will fail due to `fontspec`.

See `source/wildcat-demo.pdf` for a full reference of all features, or open the [Overleaf template](https://www.overleaf.com/latex/templates/wildcat/knynymwgrxxj) to get started immediately.

## Theme Options

All options can be combined in a single line:

```latex
\usetheme[
  pattern=triangle,
  color=nudarkblue,
  font=poppins,
  numbering=progressbar,
  sectionpage=on,
  agendastyle=pattern,
  breadcrumb=on
]{wildcat}
```

### Background Patterns (`pattern=`)
12 built-in patterns ship with the theme:

| Option | Description |
|---|---|
| `facet` *(default)* | NU facet design |
| `facetrand` | NU facets (alternate arrangement) |
| `triangle` | Triangle mosaic |
| `triangleiso` | Isometric triangles |
| `trianglemesh` | Wireframe mesh |
| `squares` | Square grid |
| `circles` | Circles |
| `hexraise` | Raised hex clusters |
| `hexrand` | Random hex shading |
| `network` | Network/graph grid |
| `quilt` | Quilt rings |
| `plain` | Solid color fill |

See `source/wildcat-gallery.pdf` for a visual preview of all patterns.

### Agenda Style (`agendastyle=`)

Agenda and section divider pages use a 60% white content panel by default:

```latex
\usetheme[agendastyle=plain]{wildcat}    % default
\usetheme[agendastyle=pattern]{wildcat}  % show the active pattern on the right 40%
```

### Section Pages (`sectionpage=`)

Section divider pages are inserted automatically before each section:

```latex
\usetheme[sectionpage=on]{wildcat}    % default
\usetheme[sectionpage=none]{wildcat}  % disable section divider pages
```

### Slide Numbering (`numbering=`)

Slide numbers exclude the title page and are hidden on title, plain, section, standout, and appendix slides:

```latex
\usetheme[numbering=fraction]{wildcat}     % default: n/N
\usetheme[numbering=number]{wildcat}       % slide number only
\usetheme[numbering=progressbar]{wildcat}  % bottom progress bar
\usetheme[numbering=none]{wildcat}         % no numbering
```

### Breadcrumbs (`breadcrumb=`)

Frame-title breadcrumbs show the current section and subsection above normal slide titles:

```latex
\usetheme[breadcrumb=none]{wildcat}  % default
\usetheme[breadcrumb=on]{wildcat}
```

### Colors (`color=`)
Pass any named color to change the primary theme color. All lighter and darker shades are generated automatically:

```latex
\usetheme[color=nudarkblue]{wildcat}
```

All `nu*` palette colors (nupurple, nudarkblue, nubrightgreen, etc.) are available. Standard xcolor names (red, blue, etc.) also work. For precise per-shade control, redefine individual `wcprimary10`–`wcprimary40` and `wcprimary110`–`wcprimary140` colors after `\usetheme`.

### Fonts (`font=`)

| Option | Fonts | Files needed |
|---|---|---|
| *(default)* | Fira Sans | None — works on Overleaf, MiKTeX, TeX Live |
| `noto` | Noto Sans | None — works on Overleaf and TeX Live |
| `poppins` | [Poppins](https://fonts.google.com/specimen/Poppins) + [IBM Plex Sans](https://fonts.google.com/specimen/IBM+Plex+Sans) | TTF files in `fonts/` (free from Google Fonts) |
| `nu` | Campton + Akkurat Pro | OTF files in `fonts/` (Northwestern brand fonts) |
| `installed` | Campton + Akkurat Pro | Must be installed as system fonts |

The default (Fira Sans) requires no setup — it is pre-installed on Overleaf and auto-installs on MiKTeX. For TeX Live, run `tlmgr install fira` if not found. The `font=poppins` option expects the downloaded font files in `fonts/Poppins/` and `fonts/IBM_Plex_Sans/`.

## Custom Background Patterns
You can load a custom background pattern from a `.tex` file in your preamble **after** `\usetheme`:

```latex
\usetheme{wildcat}
\input{bg-gallery/bg-template}   % use \input, not \include
```

The `source/bg-gallery/` folder contains:
- `bg-template.tex` — a contribution template with full instructions
- `bg-voronoi.tex` — a Voronoi diagram pattern (15 seeds)

**Want to contribute a pattern?** Copy `bg-template.tex`, add your TikZ drawing commands, and open a pull request at [github.com/aarondwolf/wildcat](https://github.com/aarondwolf/wildcat). Community patterns are welcome!

## Overleaf

Users on Overleaf can use the [Overleaf template](https://www.overleaf.com/latex/templates/wildcat/knynymwgrxxj) to get started quickly.

- The default font (Fira Sans) and Noto fonts (`font=noto`) work on Overleaf out of the box
- The `font=poppins` option works if the TTF files are uploaded to the project
- The Northwestern logo is not included in the Overleaf template; download it [here](https://github.com/aarondwolf/wildcat/blob/main/source/logo-northwestern.pdf) or replace it with your own logo

## Issues
There are no known issues at the moment. Please [create an issue](https://github.com/aarondwolf/wildcat/issues) if something isn't working. 
