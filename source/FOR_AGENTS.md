# Agent Guide: Wildcat Beamer Presentation Theme

> **Repository context:**
> The upstream repository is [`https://github.com/aarondwolf/wildcat`](https://github.com/aarondwolf/wildcat).
> The Beamer presentation source files live in the `source/` directory:
> `https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/`
>
> **Goal:** When a user asks you to create a new presentation or adapt an existing one using the Wildcat Beamer theme in a specific project folder, follow this guide to fetch individual style files directly from GitHub (do **not** clone the full repository) and set up the presentation.

---

## 1. Quick Summary of Required Assets

To compile a Wildcat Beamer presentation, the target folder needs the core `.sty` files in the same directory as the `.tex` presentation (or on the LaTeX search path):

| File | Purpose | Raw Download URL |
| :--- | :--- | :--- |
| `beamerthemewildcat.sty` | Main theme loader and option parser | `https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/beamerthemewildcat.sty` |
| `beamercolorthemewildcat.sty` | Northwestern & Wildcat color definitions | `https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/beamercolorthemewildcat.sty` |
| `beamerinnerthemewildcat.sty` | TikZ geometric patterns, title page, tcolorbox blocks | `https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/beamerinnerthemewildcat.sty` |
| `beamerouterthemewildcat.sty` | Frame titles, footers, breadcrumbs, progress bars | `https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/beamerouterthemewildcat.sty` |
| `beamerfontthemewildcat.sty` | Font theme switcher (Fira Sans, Noto, Poppins, Campton) | `https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/beamerfontthemewildcat.sty` |
| `logo-northwestern.pdf` | Northwestern "N" logo for title/divider slides | `https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/logo-northwestern.pdf` |

---

## 2. Agent Initialization Workflow

When the user specifies a target folder (e.g., `./presentation/` or current directory):

### Step 1: Ensure Target Directory Exists
```bash
mkdir -p <target-folder>
cd <target-folder>
```

### Step 2: Fetch the Style Files (No Repo Cloning)
Download each individual style file directly into the target presentation folder.

#### Using Bash / `curl`:
```bash
BASE_URL="https://raw.githubusercontent.com/aarondwolf/wildcat/main/source"
curl -fsSL "$BASE_URL/beamerthemewildcat.sty" -o beamerthemewildcat.sty
curl -fsSL "$BASE_URL/beamercolorthemewildcat.sty" -o beamercolorthemewildcat.sty
curl -fsSL "$BASE_URL/beamerinnerthemewildcat.sty" -o beamerinnerthemewildcat.sty
curl -fsSL "$BASE_URL/beamerouterthemewildcat.sty" -o beamerouterthemewildcat.sty
curl -fsSL "$BASE_URL/beamerfontthemewildcat.sty" -o beamerfontthemewildcat.sty
curl -fsSL "$BASE_URL/logo-northwestern.pdf" -o logo-northwestern.pdf
```

#### Using PowerShell:
```powershell
$baseUrl = "https://raw.githubusercontent.com/aarondwolf/wildcat/main/source"
$files = @(
    "beamerthemewildcat.sty",
    "beamercolorthemewildcat.sty",
    "beamerinnerthemewildcat.sty",
    "beamerouterthemewildcat.sty",
    "beamerfontthemewildcat.sty",
    "logo-northwestern.pdf"
)
foreach ($file in $files) {
    Invoke-WebRequest -Uri "$baseUrl/$file" -OutFile $file
}
```

#### Using Python:
```python
import urllib.request

base_url = "https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/"
files = [
    "beamerthemewildcat.sty",
    "beamercolorthemewildcat.sty",
    "beamerinnerthemewildcat.sty",
    "beamerouterthemewildcat.sty",
    "beamerfontthemewildcat.sty",
    "logo-northwestern.pdf",
]
for fname in files:
    urllib.request.urlretrieve(base_url + fname, fname)
```

---

## 3. Font Selection & Assets

- **Default (`font=` omitted)**: Uses **Fira Sans**, which ships standard with TeX Live and MiKTeX and works out-of-the-box on Overleaf. **No local font files needed.**
- **`font=noto`**: Uses Noto Sans. Works on TeX Live / Overleaf with no local font files needed.
- **`font=poppins`**: Uses Poppins (headings) + IBM Plex Sans (body). If the user requests this, download the open-source font TTF files into `fonts/Poppins/` and `fonts/IBM_Plex_Sans/` from the repository:
  ```
  https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/fonts/Poppins/...
  https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/fonts/IBM_Plex_Sans/...
  ```
- **`font=nu` or `font=installed`**: Campton + Akkurat Pro. These are proprietary Northwestern fonts requiring local installation or licensed OTF files.

---

## 4. Setting Up the Presentation

Depending on what the user wants, choose **Mode A** or **Mode B**:

### Mode A: Initializing a New Presentation
If the user wants to start a fresh presentation, you can either:

1. **Download the full demo file** as a starting template:
   ```bash
   curl -fsSL "https://raw.githubusercontent.com/aarondwolf/wildcat/main/source/wildcat-demo.tex" -o main.tex
   ```
2. **Or create a clean minimal starter template (`main.tex`)**:
   ```latex
   \documentclass[aspectratio=169, 10pt]{beamer}

   % Load Wildcat theme
   \usetheme[
     pattern=facet,        % facet, triangle, circles, network, quilt, plain, etc.
     color=nupurple,       % primary theme color (nupurple, nudarkblue, etc.)
     numbering=fraction,   % fraction (n/N), number, progressbar, none
     sectionpage=on        % divider slides for \section{}
   ]{wildcat}

   \title{Presentation Title}
   \subtitle{Presentation Subtitle}
   \author{Presenter Name}
   \institute{Northwestern University}
   \date{\today}
   \titlegraphic{\includegraphics[height=1.2cm]{logo-northwestern.pdf}}

   \begin{document}

   \maketitle

   \section{Introduction}

   \begin{frame}{Slide Title}{Optional Subtitle}
     \begin{itemize}
       \item First point highlighting key research finding.
       \item Second point with supporting evidence.
     \end{itemize}

     \begin{tblock}{Highlighted Takeaway}
       Use \texttt{tblock}, \texttt{talert}, or \texttt{texample} for modern styled boxes.
     \end{tblock}
   \end{frame}

   \standout{Thank You!}

   \end{document}
   ```

### Mode B: Adapting an Existing Presentation
If the user already has an existing Beamer `.tex` file (e.g. `slides.tex`):

1. **Do not overwrite their original file.** Make a copy with `_wildcat.tex` appended to the filename:
   ```bash
   cp slides.tex slides_wildcat.tex
   ```
2. **Update the preamble in `slides_wildcat.tex`**:
   - Replace any existing theme declaration (e.g., `\usetheme{metropolis}`, `\usetheme{Madrid}`, etc.) with:
     ```latex
     \usetheme[pattern=facet, numbering=fraction, sectionpage=on]{wildcat}
     ```
   - Keep the user's existing packages, titles, and body frames intact.
   - If they have standard Beamer blocks (`block`, `alertblock`, `exampleblock`), they will continue to work, but you can optionally upgrade key callouts to `tblock`, `talert`, or `texample` for the signature geometric pattern styling.

---

## 5. Compiling the Presentation

> [!IMPORTANT]
> **Compilation Engine:** You **MUST** use **XeLaTeX** or **LuaLaTeX**.
> Standard `pdflatex` will fail because the theme relies on `fontspec` for font management.

Run compilation twice to resolve slide numbering and cross-references:

```bash
xelatex main.tex
xelatex main.tex
```

Or with LuaLaTeX:
```bash
lualatex main.tex
lualatex main.tex
```

---

## 6. Theme Options Quick Reference

| Option | Values | Default | Description |
| :--- | :--- | :--- | :--- |
| `pattern=` | `facet`, `facetrand`, `triangle`, `triangleiso`, `trianglemesh`, `squares`, `circles`, `hexraise`, `hexrand`, `network`, `quilt`, `plain` | `facet` | Geometric background pattern |
| `color=` | `nupurple`, `nudarkblue`, `nudarkgreen`, `nudarkorange`, `nudarkteal`, or any standard xcolor name | `nupurple` | Main theme color (auto-generates lighter & darker shades) |
| `font=` | *(omitted)* (Fira Sans), `noto`, `poppins`, `nu`, `installed` | Fira Sans | Typography loader |
| `numbering=` | `fraction` (n/N), `number`, `progressbar`, `none` | `fraction` | Slide number formatting in footer |
| `sectionpage=`| `on`, `none` | `on` | Automatic section divider slides |
| `agendastyle=`| `plain`, `pattern` | `plain` | Right panel design on section pages |
| `breadcrumb=` | `none`, `on` | `none` | Breadcrumbs in slide headers showing section/subsection |

### Custom Environments
- `\begin{tblock}{Title} ... \end{tblock}`: Primary-colored patterned box.
- `\begin{talert}{Title} ... \end{talert}`: Alert-colored patterned box (`nudarkorange`).
- `\begin{texample}{Title} ... \end{texample}`: Example-colored patterned box (`nudarkgreen`).
- `\begin{tpatternbox}[color]{Title} ... \end{tpatternbox}`: Custom color patterned box.
- `\standout{Large Centered Text}`: Full-slide pattern background for transitions or Q&A.
