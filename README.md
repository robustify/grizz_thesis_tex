# grizz_thesis_tex

A LaTeX document class for Oakland University theses and dissertations.
In addition to the document class, there is an example of how to use it as well as an AI-generated test document to make sure a full-size document does not trigger corner cases that don't typeset properly.

Reference images used in example figures are taken from the [NASA Image and Video Library](https://images.nasa.gov/).

## Repository Structure

```
example/
  tex/
    main.tex          # Top-level document (entry point)
    grizz_thesis.cls  # Document class — copy this into your project
    .latexmkrc        # latexmk build configuration (handles glossaries)
    chapter1.tex      # Example chapter
    chapter2.tex      # Example chapter
    appendixA.tex     # Example appendix
    front_matter.tex  # TOC, LOF, LOT, abbreviations
    references.bib    # BibTeX bibliography
```

## Building with VS Code and LaTeX Workshop

### Prerequisites (all platforms)

1. Install [VS Code](https://code.visualstudio.com/)
2. Install the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension

---

### Linux

**Install TeX Live and latexmk**

On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install texlive-latex-extra texlive-latex-recommended latexmk
```

The `texlive-latex-extra` package includes all packages required by `grizz_thesis.cls`:
`geometry`, `graphicx`, `etoolbox`, `fmtcount`, `glossaries`, `fancyhdr`,
`setspace`, `titlesec`, `titletoc`, `tocloft`, `ulem`, `hyperref`.

If you prefer a hassle-free full install (larger download, ~5 GB):

```bash
sudo apt install texlive-full latexmk
```

On Fedora/RHEL:

```bash
sudo dnf install texlive-scheme-medium latexmk
```

---

### Windows

**Option A: MiKTeX (recommended)**

MiKTeX automatically installs missing LaTeX packages on first build, so no manual package management is needed.

1. Download and install [MiKTeX](https://miktex.org/download). Choose the "Complete MiKTeX" installer, or use the basic installer and let it auto-install packages on demand.
2. Install [Strawberry Perl](https://strawberryperl.com/) — `latexmk` is a Perl script and requires Perl to run on Windows.
3. Open the MiKTeX Console, go to **Updates**, and click **Check for updates** / **Update now** to ensure packages are current.

**Option B: TeX Live for Windows**

1. Download the [TeX Live installer](https://tug.org/texlive/windows.html).
2. Run `install-tl-windows.exe` and select the **full scheme** (recommended) or at minimum `scheme-medium`.
3. Strawberry Perl is **not** needed — TeX Live for Windows bundles its own Perl.

---

### VS Code / LaTeX Workshop Configuration

LaTeX Workshop uses `latexmk` by default, which is all that is needed here. The `.latexmkrc` file in `example/tex/` automatically instructs `latexmk` to run `makeglossaries` so the List of Abbreviations is built correctly.

**No extra VS Code settings are required** for a standard setup. However, if you want to explicitly set the default recipe, add the following to your VS Code `settings.json` (File → Preferences → Settings → Open Settings JSON):

```json
{
  "latex-workshop.latex.recipes": [
    {
      "name": "latexmk (pdflatex)",
      "tools": ["latexmk"]
    }
  ],
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": [
        "-pdf",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ]
    }
  ]
}
```

---

### Building the Example Document

1. Open the `example/tex/` folder in VS Code.
2. Open `main.tex`.
3. LaTeX Workshop will build the document automatically on save, or you can trigger a build manually with **Ctrl+Alt+B** (macOS: **Cmd+Alt+B**).
4. The compiled PDF is saved as `main.pdf` in the same directory.

**Build order** (handled automatically by `latexmk` + `.latexmkrc`):

1. `pdflatex` — generates `.aux` and `.glo` files
2. `makeglossaries` — generates the List of Abbreviations (`.gls`)
3. `bibtex` — generates the bibliography (`.bbl`)
4. `pdflatex` (×2) — resolves cross-references and finalizes the PDF

---

### Bibliography Style

`main.tex` defaults to IEEE (`ieeetr`). To switch to APA, comment out the IEEE line and uncomment the APA lines:

```latex
% \bibliographystyle{ieeetr}

\usepackage{apacite}
\bibliographystyle{apacite}
```

APA requires the `apacite` package. On Linux, install it with:

```bash
sudo apt install texlive-bibtex-extra
```

MiKTeX and TeX Live full installs include it automatically.

If you use a different bibliography style, feel free to open a pull request that adds its configuration as an option to the example document. Also, modify this README with instructions to install the necessary packages, if applicable.
