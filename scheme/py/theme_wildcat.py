"""
theme_wildcat.py
================
Wildcat Graph Styling & Northwestern University Brand Color System for Python / Matplotlib.
Synchronized with R ggplot2 (theme_wildcat) and Stata (scheme-wildcat).
"""

from pathlib import Path
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
from cycler import cycler

# ------------------------------------------------------------------------------
# 1. Northwestern University Brand Colors & Wildcat Theme Elements
# ------------------------------------------------------------------------------
# Official Northwestern University Brand Palette
# Reference: https://www.northwestern.edu/brand/
wildcat_colors = {
    # Primary Brand Colors
    "nupurple":       "#4E2A84",  # RGB: 78 42 132  - Primary Northwestern Purple
    "nupurple150":    "#260841",  # RGB: 38 8 65    - Deep Purple
    "nupurple50":     "#9380C0",  # RGB: 147 128 192 - Light Purple
    "nupurple40":     "#A495C3",  # RGB: 164 149 195 - Muted Tint
    "nupurple20":     "#CCC4DF",  # RGB: 204 196 223 - Soft Tint

    # Secondary Palette (Bright)
    "nubrightgreen":  "#58B9AB",  # RGB: 88 185 171
    "nubrightteal":   "#7FCECD",  # RGB: 127 206 205
    "nubrightblue":   "#5091CD",  # RGB: 80 145 205
    "nubrightyellow": "#EDE93B",  # RGB: 237 233 59
    "nubrightorange": "#FFC520",  # RGB: 255 197 32
    "nubrightred":    "#EF553F",  # RGB: 239 85 63

    # Secondary Palette (Dark)
    "nudarkgreen":    "#008656",  # RGB: 0 134 86
    "nudarkteal":     "#007FA4",  # RGB: 0 127 164
    "nudarkblue":     "#0D2D6C",  # RGB: 13 45 108
    "nudarkyellow":   "#D9C826",  # RGB: 217 200 38
    "nudarkorange":   "#CA7C1B",  # RGB: 202 124 27
    "nudarkred":      "#D85820",  # RGB: 216 88 32

    # Brand Neutral
    "nurichblack":    "#000000",  # RGB: 0 0 0

    # Wildcat Theme Structural & Semantic Colors
    # Calibrated to exact R ggplot2 defaults:
    "wc_bg":          "#FFFFFF",  # Pure white canvas
    "wc_title":       "#222222",  # Dark charcoal for titles and headings
    "wc_body":        "#666666",  # Muted medium gray for subtitles, captions, ticks
    "wc_grid":        "#EAEAEA",  # Thin light gray horizontal gridlines
    "wc_axis":        "#CCCCCC",  # Subtle axis baseline and ticks
}

# Backward-compatibility alias
nu_colors = wildcat_colors

# ------------------------------------------------------------------------------
# 2. Palette Definitions
# ------------------------------------------------------------------------------
wildcat_palettes = {
    # Default categorical sequence mapped for maximum contrast and accessibility
    "default": [
        wildcat_colors["nupurple"],        # plot1
        wildcat_colors["nudarkorange"],    # plot2
        wildcat_colors["nubrightblue"],    # plot3
        wildcat_colors["nudarkgreen"],     # plot4
        wildcat_colors["nubrightorange"],  # plot5
        wildcat_colors["nubrightteal"],    # plot6
        wildcat_colors["nubrightred"],     # plot7
        wildcat_colors["nudarkblue"],      # plot8
        wildcat_colors["nudarkteal"],      # plot9
        wildcat_colors["nubrightgreen"],   # plot10
        wildcat_colors["nudarkyellow"],    # plot11
        wildcat_colors["nupurple50"],      # plot12
    ],
    "purple": [
        wildcat_colors["nupurple150"],
        wildcat_colors["nupurple"],
        wildcat_colors["nupurple50"],
        wildcat_colors["nupurple40"],
        wildcat_colors["nupurple20"],
    ],
    "bright": [
        wildcat_colors["nupurple"],
        wildcat_colors["nudarkorange"],
        wildcat_colors["nubrightblue"],
        wildcat_colors["nubrightgreen"],
        wildcat_colors["nubrightteal"],
        wildcat_colors["nubrightorange"],
        wildcat_colors["nubrightred"],
        wildcat_colors["nubrightyellow"],
    ],
    "dark": [
        wildcat_colors["nupurple150"],
        wildcat_colors["nudarkorange"],
        wildcat_colors["nudarkblue"],
        wildcat_colors["nudarkteal"],
        wildcat_colors["nudarkgreen"],
        wildcat_colors["nudarkred"],
        wildcat_colors["nudarkyellow"],
    ],
    "two_color": [
        wildcat_colors["nupurple"],
        wildcat_colors["nudarkorange"],
    ],
}

nu_palettes = wildcat_palettes

# Colormaps
cmap_wildcat_purple = LinearSegmentedColormap.from_list(
    "wildcat_purple",
    [wildcat_colors["nupurple20"], wildcat_colors["nupurple"], wildcat_colors["nupurple150"]]
)
cmap_wildcat_diverging = LinearSegmentedColormap.from_list(
    "wildcat_diverging",
    [wildcat_colors["nudarkorange"], "#FFFFFF", wildcat_colors["nupurple"]]
)

# ------------------------------------------------------------------------------
# 3. Theme Application & rcParams
# ------------------------------------------------------------------------------
STYLE_FILE = Path(__file__).parent / "wildcat.mplstyle"

def get_wildcat_rcparams(base_size=11.0, font_family="sans-serif"):
    """Return dictionary of rcParams configured for Wildcat theme."""
    scale = base_size / 11.0
    return {
        # Canvas & Figure
        "figure.facecolor": wildcat_colors["wc_bg"],
        "figure.edgecolor": wildcat_colors["wc_bg"],
        "figure.dpi": 300,
        "figure.figsize": (8.0, 5.0),
        "figure.autolayout": False,
        "figure.subplot.left": 0.075,
        "figure.subplot.right": 0.972,
        "figure.subplot.bottom": 0.177,
        "figure.subplot.top": 0.810,

        # Typography
        "font.family": font_family,
        "font.sans-serif": ["Arial", "Helvetica", "DejaVu Sans"],
        "font.size": base_size,
        "text.color": wildcat_colors["wc_body"],

        # Axes & Frames
        "axes.facecolor": wildcat_colors["wc_bg"],
        "axes.edgecolor": wildcat_colors["wc_axis"],
        "axes.linewidth": 0.75,
        "axes.grid": True,
        "axes.grid.axis": "y",
        "axes.grid.which": "major",
        "axes.axisbelow": True,

        # Title & Labels
        "axes.titlesize": 14.3 * scale,
        "axes.titleweight": "bold",
        "axes.titlecolor": wildcat_colors["wc_title"],
        "axes.titlelocation": "left",
        "axes.titlepad": 14.0,
        "axes.labelsize": 10.5 * scale,
        "axes.labelcolor": wildcat_colors["wc_title"],
        "axes.labelweight": "normal",
        "axes.labelpad": 6.0,

        # Spines
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.spines.left": False,
        "axes.spines.bottom": True,

        # Ticks
        "xtick.bottom": True,
        "xtick.top": False,
        "xtick.color": wildcat_colors["wc_axis"],
        "xtick.labelcolor": wildcat_colors["wc_body"],
        "xtick.labelsize": 9.35 * scale,
        "xtick.direction": "out",
        "xtick.major.size": 3.5,
        "xtick.major.width": 0.75,

        "ytick.left": False,
        "ytick.right": False,
        "ytick.labelcolor": wildcat_colors["wc_body"],
        "ytick.labelsize": 9.35 * scale,
        "ytick.major.size": 0,
        "ytick.minor.size": 0,

        # Gridlines
        "grid.color": wildcat_colors["wc_grid"],
        "grid.linestyle": "-",
        "grid.linewidth": 0.8,
        "grid.alpha": 1.0,

        # Color Cycle
        "axes.prop_cycle": cycler(color=wildcat_palettes["default"]),

        # Lines & Markers
        "lines.linewidth": 1.8,
        "lines.markersize": 6.0,
        "lines.solid_capstyle": "round",
        "patch.linewidth": 0.75,
        "patch.edgecolor": "none",

        # Legend
        "legend.frameon": False,
        "legend.framealpha": 0.0,
        "legend.facecolor": "none",
        "legend.edgecolor": "none",
        "legend.fontsize": 9.35 * scale,
        "legend.title_fontsize": 9.9 * scale,
        "legend.loc": "upper left",
        "legend.borderpad": 0.2,
        "legend.columnspacing": 1.2,
        "legend.handlelength": 1.0,
        "legend.handleheight": 1.0,
        "legend.handletextpad": 0.4,
    }

def set_theme(base_size=11.0, font_family="sans-serif", palette="default"):
    """Apply the Wildcat theme globally to Matplotlib rcParams."""
    params = get_wildcat_rcparams(base_size=base_size, font_family=font_family)
    if palette != "default" and palette in wildcat_palettes:
        params["axes.prop_cycle"] = cycler(color=wildcat_palettes[palette])
    plt.rcParams.update(params)

def theme_wildcat(base_size=11.0, font_family="sans-serif", palette="default"):
    """Alias for set_theme()."""
    set_theme(base_size=base_size, font_family=font_family, palette=palette)

theme_nu = theme_wildcat

# ------------------------------------------------------------------------------
# 4. Helper Functions: labs() & legend_top()
# ------------------------------------------------------------------------------
def legend_top(ax, ncol=None, handles=None, labels=None, x=None, y=0.840, **kwargs):
    """
    Format a top-placed, horizontal legend matching R ggplot2 theme(legend.position = 'top').

    Parameters
    ----------
    ax : matplotlib.axes.Axes
        Target axes.
    ncol : int, optional
        Number of columns (default: number of legend items).
    handles : list, optional
        Artist handles.
    labels : list, optional
        Legend labels.
    x : float, optional
        Left anchor in figure coordinates (default: ax.get_position().x0).
    y : float, optional
        Vertical center anchor in figure coordinates (default: 0.840, matching R's row 236 px).
    **kwargs
        Additional arguments passed to ax.legend().
    """
    fig = ax.figure
    x0 = x if x is not None else ax.get_position().x0

    opts = dict(
        loc="center left",
        bbox_to_anchor=(x0, y),
        bbox_transform=fig.transFigure,
        frameon=False,
        fontsize=9.35,
        handletextpad=0.4,
        columnspacing=1.0,
        handlelength=1.0,
        handleheight=1.0
    )
    if ncol is not None:
        opts["ncol"] = ncol
    opts.update(kwargs)

    if handles is not None and labels is not None:
        return ax.legend(handles, labels, **opts)
    elif handles is not None:
        return ax.legend(handles=handles, **opts)
    return ax.legend(**opts)


def labs(target, title=None, subtitle=None, caption=None, x=None, y=None, top_legend=False):
    """
    Format chart titles, subtitles, and captions in ggplot2 style.

    Parameters
    ----------
    target : matplotlib.axes.Axes, matplotlib.figure.Figure, or list/tuple of Axes
        Target axes or figure.
    title : str, optional
        Main title (bold, dark charcoal #222222, flush left).
    subtitle : str, optional
        Subtitle (plain, muted gray #666666, placed directly below main title).
    caption : str, optional
        Footnote / source note (plain, small muted gray #666666, placed at bottom-left).
    x : str, optional
        X-axis label.
    y : str, optional
        Y-axis label.
    top_legend : bool, optional
        Set to True if the chart contains a top-mounted legend, reserving vertical
        spacing between subtitle and plot area (default: False).
    """
    if isinstance(target, (list, tuple)):
        ax = target[0]
        fig = ax.figure
    elif isinstance(target, mpl.figure.Figure):
        fig = target
        ax = fig.axes[0] if fig.axes else None
    else:
        ax = target
        fig = ax.figure

    if ax is not None:
        if x is not None:
            ax.set_xlabel(x, fontsize=10.5, color=wildcat_colors["wc_title"], labelpad=6)
        if y is not None:
            ax.set_ylabel(y, fontsize=10.5, color=wildcat_colors["wc_title"], labelpad=6)

    # Automatically adjust subplot bounds to match R ggplot2 panel aspect ratio
    has_top_legend = top_legend
    if not has_top_legend and ax is not None and ax.get_legend() is not None:
        has_top_legend = True

    if has_top_legend:
        # Top margin for charts with a top legend:
        # Title (0.938), Subtitle (0.893), Legend (0.75-0.80), Panel Top (0.745), Panel Bottom (0.177)
        fig.subplots_adjust(top=0.745, bottom=0.177)
    else:
        # Panel Top (0.810), Panel Bottom (0.177) matching R panel aspect ratio
        fig.subplots_adjust(top=0.810, bottom=0.177)

    x0 = ax.get_position().x0 if ax is not None else 0.075

    # In R ggplot2, title is bold #222222, subtitle is plain #666666
    if title and subtitle:
        fig.text(
            x0, 0.938, title,
            fontsize=13.5,
            fontweight="bold",
            color=wildcat_colors["wc_title"],
            ha="left", va="bottom",
            fontfamily="sans-serif"
        )
        fig.text(
            x0, 0.893, subtitle,
            fontsize=10.2,
            fontweight="normal",
            color=wildcat_colors["wc_body"],
            ha="left", va="bottom",
            fontfamily="sans-serif"
        )
    elif title:
        fig.text(
            x0, 0.925, title,
            fontsize=13.5,
            fontweight="bold",
            color=wildcat_colors["wc_title"],
            ha="left", va="bottom",
            fontfamily="sans-serif"
        )
    elif subtitle:
        fig.text(
            x0, 0.925, subtitle,
            fontsize=10.2,
            fontweight="normal",
            color=wildcat_colors["wc_body"],
            ha="left", va="bottom",
            fontfamily="sans-serif"
        )

    if caption:
        fig.text(
            x0, 0.045, caption,
            ha="left", va="bottom",
            fontsize=9.0,
            fontweight="normal",
            color=wildcat_colors["wc_body"],
            fontfamily="sans-serif"
        )
