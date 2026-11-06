"""
test_py_plots.py
================
Comprehensive Validation Suite for Wildcat Python / Matplotlib Theme (theme_wildcat).
Generates 16 synchronized, publication-grade chart types matching R ggplot2 outputs.
"""

from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

# Ensure local 'py' package is available
import sys
ROOT_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT_DIR))

from py.theme_wildcat import set_theme, wildcat_colors, wildcat_palettes, labs, legend_top

# Set global theme
set_theme()

OUTPUT_DIR = ROOT_DIR / "output_checks"
OUTPUT_DIR.mkdir(exist_ok=True)

DATA_DIR = ROOT_DIR / "data"

# Standard export dimensions (8" x 5" at 300 DPI = 2400 x 1500 px)
PLOT_W = 8.0
PLOT_H = 5.0
DPI = 300

# Load shared auto dataset
auto_path = DATA_DIR / "auto.dta"
if auto_path.exists():
    auto = pd.read_stata(auto_path, convert_categoricals=False)
else:
    raise FileNotFoundError(f"{auto_path} not found.")

rating_names = ["Poor (1)", "Fair (2)", "Average (3)", "Good (4)", "Excellent (5)"]
auto["origin"] = auto["foreign"].map({0: "Domestic", 1: "Foreign"})


# ==============================================================================
# Plot 1: Scatter plot with linear fit & 95% CI ribbon
# ==============================================================================
fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

x = auto["weight"].dropna()
y = auto.loc[x.index, "mpg"]

# Fit OLS
res = stats.linregress(x, y)
x_line = np.linspace(x.min(), x.max(), 150)
y_line = res.intercept + res.slope * x_line

# 95% Confidence Interval for mean expectation
n = len(x)
y_pred = res.intercept + res.slope * x
s_err = np.sqrt(np.sum((y - y_pred)**2) / (n - 2))
t_val = stats.t.ppf(0.975, df=n - 2)
ci = t_val * s_err * np.sqrt(1/n + (x_line - x.mean())**2 / np.sum((x - x.mean())**2))

# 95% CI Ribbon (soft tint purple #CCC4DF)
ax.fill_between(x_line, y_line - ci, y_line + ci, color=wildcat_colors["nupurple20"], alpha=1.0, edgecolor="none", zorder=2)
# Regression Line
ax.plot(x_line, y_line, color=wildcat_colors["nupurple"], linewidth=1.8, zorder=3)
# Scatter Points
ax.scatter(x, y, color=wildcat_colors["nupurple"], s=28, alpha=0.90, edgecolors="none", zorder=4)

ax.set_xlim(1700, 4900)
ax.set_xticks(np.arange(2000, 4001, 1000))
ax.set_ylim(7, 43)
ax.set_yticks(np.arange(10, 41, 10))

labs(
    ax,
    title="Automobile Weight vs. Fuel Efficiency",
    subtitle="Linear fit with 95% confidence ribbon",
    x="Vehicle Weight (lbs.)",
    y="Mileage (mpg)",
    caption="Source: 1978 Automobile Data"
)

plt.savefig(OUTPUT_DIR / "py_scatter.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 2: Horizontal bar chart across repair categories
# ==============================================================================
auto_agg = auto.dropna(subset=["rep78"]).groupby("rep78")["mpg"].mean().reset_index()

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

# In R: coord_flip with rev(rating_names) on Y-axis
y_pos = np.arange(len(auto_agg))[::-1]
colors = wildcat_palettes["default"][:len(auto_agg)]

bars = ax.barh(y_pos, auto_agg["mpg"], height=0.62, color=colors, edgecolor="none", zorder=3)

# Gridlines on X-axis only for horizontal bar chart
ax.xaxis.grid(True, color=wildcat_colors["wc_grid"], linewidth=0.8, zorder=1)
ax.yaxis.grid(False)
ax.spines["left"].set_visible(False)
ax.spines["bottom"].set_visible(True)
ax.spines["bottom"].set_color(wildcat_colors["wc_axis"])
ax.tick_params(axis="y", length=0, labelsize=0) # Hide Y ticks/labels matching R custom theme
ax.set_yticks([])

ax.set_xlim(0, 30)
ax.set_xticks(np.arange(0, 31, 10))

# Legend at top
for idx, (b, name) in enumerate(zip(bars, rating_names)):
    b.set_label(name)
legend_top(ax, ncol=5)

labs(
    ax,
    title="Average Fuel Efficiency by Repair Record",
    subtitle="Mean miles per gallon across 1978 repair ratings",
    x="Mean Mileage (mpg)",
    caption="Source: 1978 Automobile Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_bar.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 3: Multi-panel faceted plot (by origin)
# ==============================================================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(PLOT_W, PLOT_H), sharey=True, dpi=DPI)

dom = auto[auto["foreign"] == 0]
for_data = auto[auto["foreign"] == 1]

# Plot points
ax1.scatter(dom["weight"], dom["mpg"], color=wildcat_colors["nupurple"], s=28, alpha=0.90, edgecolors="none")
ax2.scatter(for_data["weight"], for_data["mpg"], color=wildcat_colors["nudarkorange"], s=28, alpha=0.90, edgecolors="none")

for ax_panel, name in zip([ax1, ax2], ["Domestic", "Foreign"]):
    ax_panel.set_xlim(1700, 4900)
    ax_panel.set_xticks(np.arange(2000, 4001, 1000))
    ax_panel.set_ylim(7, 43)
    ax_panel.set_yticks(np.arange(10, 41, 10))
    # Facet strip title above panel
    ax_panel.set_title(
        name,
        fontsize=11.55,
        fontweight="bold",
        color=wildcat_colors["wc_title"],
        pad=8.0,
        loc="center"
    )

ax1.set_ylabel("Mileage (mpg)", fontsize=10.5, color=wildcat_colors["wc_title"])

# Centered single x-axis label across panels
fig.text(0.523, 0.080, "Vehicle Weight (lbs.)", ha="center", fontsize=10.5, color=wildcat_colors["wc_title"])

plt.subplots_adjust(left=0.075, right=0.972, bottom=0.177, top=0.770, wspace=0.06)

labs(
    (ax1, ax2),
    title="Mileage vs. Weight by Vehicle Origin",
    subtitle="Comparison of Domestic vs. Foreign automobiles",
    caption="Source: 1978 Automobile Data"
)

plt.savefig(OUTPUT_DIR / "py_facet.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 4: Box plot across repair records
# ==============================================================================
auto_box = auto.dropna(subset=["rep78", "mpg"]).copy()
auto_box["rep78_int"] = auto_box["rep78"].astype(int)
grouped_data = [auto_box[auto_box["rep78_int"] == i]["mpg"].values for i in range(1, 6)]

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

bp = ax.boxplot(
    grouped_data,
    patch_artist=True,
    widths=0.55,
    showcaps=False,  # Matches ggplot2 geom_boxplot
    showfliers=True,
    flierprops=dict(marker="o", markersize=4.5, markeredgecolor="none", alpha=0.9),
    medianprops=dict(linewidth=2.2),
    whiskerprops=dict(linewidth=1.5)
)

colors = wildcat_palettes["default"][:5]

for idx, (patch, color) in enumerate(zip(bp["boxes"], colors)):
    patch.set_facecolor(color)
    patch.set_alpha(0.40)
    patch.set_edgecolor(color)
    patch.set_linewidth(1.5)
    # Match whiskers, median
    bp["medians"][idx].set_color(color)
    bp["whiskers"][2*idx].set_color(color)
    bp["whiskers"][2*idx+1].set_color(color)
    if idx < len(bp["fliers"]):
        bp["fliers"][idx].set_markerfacecolor(color)
    patch.set_label(rating_names[idx])

legend_top(ax, ncol=5)

ax.spines["bottom"].set_visible(False)
ax.set_xticks([])
ax.set_ylim(7, 43)
ax.set_yticks(np.arange(10, 41, 10))

labs(
    ax,
    title="Fuel Efficiency Distribution by Repair Record",
    subtitle="Distribution of miles per gallon across 1978 repair ratings",
    y="Mileage (mpg)",
    caption="Source: 1978 Automobile Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_box.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 5: Multi-line time series plot (Industry Performance Trends)
# ==============================================================================
trends_path = DATA_DIR / "trends.dta"
if trends_path.exists():
    trends = pd.read_stata(trends_path)
else:
    years = np.arange(2010, 2023)
    idx = np.arange(1, 14)
    trends = pd.DataFrame({
        "year": years,
        "tech": np.round(100 * np.exp(0.088 * (idx - 1)) + 1.8 * np.sin(idx * 0.9), 1),
        "health": np.round(100 * np.exp(0.055 * (idx - 1)) + 1.2 * np.cos(idx * 0.9), 1),
        "energy": np.round(100 * np.exp(0.032 * (idx - 1)) + 2.5 * np.sin(idx * 1.5), 1)
    })

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

ax.plot(trends["year"], trends["tech"], color=wildcat_colors["nupurple"], label="Technology", linewidth=1.8)
ax.plot(trends["year"], trends["health"], color=wildcat_colors["nudarkorange"], label="Healthcare", linewidth=1.8)
ax.plot(trends["year"], trends["energy"], color=wildcat_colors["nubrightblue"], label="Energy", linewidth=1.8)

ax.set_xticks([2010, 2015, 2020])
ax.set_xlim(2009.5, 2022.5)
ax.set_yticks([100, 150, 200, 250])
ax.set_ylim(90, 290)

legend_top(ax, ncol=3, columnspacing=1.2, handlelength=1.5)

labs(
    ax,
    title="Industry Performance Trends (2010-2022)",
    subtitle="Normalized cumulative sector growth index (Base = 100)",
    x="Year",
    y="Index Value (2010 = 100)",
    caption="Source: Simulated Market Index Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_line.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 6: Kernel density distribution plot
# ==============================================================================
fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

dom_mpg = auto.loc[auto["foreign"] == 0, "mpg"].dropna()
for_mpg = auto.loc[auto["foreign"] == 1, "mpg"].dropna()

def calc_r_silverman_bw(s):
    std = s.std(ddof=1)
    iqr = stats.iqr(s)
    return 0.9 * min(std, iqr / 1.34) * (len(s) ** -0.2)

bw_dom = calc_r_silverman_bw(dom_mpg)
bw_for = calc_r_silverman_bw(for_mpg)

kde_dom = stats.gaussian_kde(dom_mpg, bw_method=bw_dom / dom_mpg.std(ddof=1))
kde_for = stats.gaussian_kde(for_mpg, bw_method=bw_for / for_mpg.std(ddof=1))

grid = np.linspace(12, 42, 250)
d_dom = kde_dom(grid)
d_for = kde_for(grid)

# Domestic
ax.fill_between(grid, 0, d_dom, color=wildcat_colors["nupurple"], alpha=0.25, edgecolor="none", zorder=2)
ax.plot(grid, d_dom, color=wildcat_colors["nupurple"], linewidth=1.8, label="Domestic", zorder=3)

# Foreign
ax.fill_between(grid, 0, d_for, color=wildcat_colors["nudarkorange"], alpha=0.25, edgecolor="none", zorder=2)
ax.plot(grid, d_for, color=wildcat_colors["nudarkorange"], linewidth=1.8, label="Foreign", zorder=3)

ax.set_xlim(12, 42)
ax.set_xticks([20, 30, 40])
ax.set_ylim(0, 0.105)
ax.set_yticks([0.000, 0.025, 0.050, 0.075, 0.100])
ax.set_yticklabels(["0.000", "0.025", "0.050", "0.075", "0.100"])

legend_top(ax, ncol=2, columnspacing=1.2, handlelength=1.5)

labs(
    ax,
    title="Fuel Efficiency Density by Origin",
    subtitle="Kernel density estimates for domestic vs. foreign automobiles",
    x="Mileage (mpg)",
    y="Density",
    caption="Source: 1978 Automobile Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_density.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 7: Cleveland Dot Plot
# ==============================================================================
fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

y_pos = np.arange(len(auto_agg))[::-1]
colors = wildcat_palettes["default"][:len(auto_agg)]

# Dotted horizontal segment from 0 to value
for y_p, val, c in zip(y_pos, auto_agg["mpg"], colors):
    ax.plot([0, val], [y_p, y_p], linestyle=":", color=wildcat_colors["wc_axis"], linewidth=1.2, zorder=2)
    ax.scatter(val, y_p, color=c, s=55, zorder=4)

ax.set_xlim(0, 30)
ax.set_xticks(np.arange(0, 31, 10))
ax.set_yticks([])
ax.spines["left"].set_visible(False)
ax.spines["bottom"].set_visible(True)
ax.xaxis.grid(True, color=wildcat_colors["wc_grid"], linewidth=0.8, zorder=1)
ax.yaxis.grid(False)

# Legend at top
for c, name in zip(colors, rating_names):
    ax.scatter([], [], color=c, s=55, label=name)
legend_top(ax, ncol=5)

labs(
    ax,
    title="Mean Fuel Efficiency by Repair Record",
    subtitle="Cleveland dot plot across repair ratings",
    x="Miles per Gallon (mpg)",
    caption="Source: 1978 Automobile Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_dot.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 8: Lollipop / Stem Plot
# ==============================================================================
lollipop_path = DATA_DIR / "lollipop.dta"
if lollipop_path.exists():
    lpop = pd.read_stata(lollipop_path)
else:
    mean_mpg = auto_agg["mpg"].mean()
    lpop = pd.DataFrame({"rep78": auto_agg["rep78"], "diff": np.round(auto_agg["mpg"] - mean_mpg, 1)})

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

ax.axhline(0, color=wildcat_colors["wc_axis"], linestyle="--", linewidth=0.9, zorder=2)

for r, d in zip(lpop["rep78"], lpop["diff"]):
    ax.plot([r, r], [0, d], color=wildcat_colors["nupurple"], linewidth=1.8, zorder=3)
    ax.scatter(r, d, color=wildcat_colors["nupurple"], s=55, zorder=4)

ax.set_xticks(np.arange(1, 6))
ax.set_xlim(0.5, 5.5)

labs(
    ax,
    title="Mileage Deviation by Repair Rating",
    subtitle="Difference from overall mean repair rating efficiency",
    x="Repair Record (1-5)",
    y="Deviation from Mean (mpg)",
    caption="Source: 1978 Automobile Data"
)

plt.savefig(OUTPUT_DIR / "py_lollipop.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 9: Coefficient / Forest Plot
# ==============================================================================
forest_path = DATA_DIR / "forest.dta"
if forest_path.exists():
    f_data = pd.read_stata(forest_path)
else:
    f_data = pd.DataFrame({
        "id": range(1, 5),
        "parm": ["Weight (lbs)", "Displacement", "Gear Ratio", "Foreign Origin"],
        "b": [-0.005, -0.012, 1.450, 2.130],
        "min95": [-0.007, -0.018, 0.900, 1.410],
        "max95": [-0.003, -0.006, 2.000, 2.850]
    })

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)
fig.subplots_adjust(left=0.145, right=0.972, bottom=0.177, top=0.810)

ax.axvline(0, color=wildcat_colors["wc_axis"], linestyle="--", linewidth=0.9, zorder=2)

y_pos = np.arange(len(f_data))
xerr_lower = f_data["b"] - f_data["min95"]
xerr_upper = f_data["max95"] - f_data["b"]

ax.errorbar(
    f_data["b"], y_pos,
    xerr=[xerr_lower, xerr_upper],
    fmt="o",
    color=wildcat_colors["nupurple"],
    ecolor=wildcat_colors["nupurple"],
    elinewidth=1.8,
    capsize=4.0,
    capthick=1.8,
    markersize=6.0,
    zorder=3
)

ax.set_yticks(y_pos)
ax.set_yticklabels(f_data["parm"])
ax.set_ylim(-0.5, len(f_data) - 0.5)
ax.set_xlim(-0.2, 3.0)
ax.set_xticks([0, 1, 2])

labs(
    ax,
    title="Regression Coefficient Estimates (95% CI)",
    subtitle="Marginal effects on vehicle fuel efficiency",
    x="Estimated Coefficient",
    y="Model Parameter",
    caption="Source: OLS Specification Estimates"
)

plt.savefig(OUTPUT_DIR / "py_forest.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 10: Dumbbell / Paired Comparison Plot
# ==============================================================================
dumbbell_path = DATA_DIR / "dumbbell.dta"
if dumbbell_path.exists():
    db_data = pd.read_stata(dumbbell_path)
else:
    db_data = pd.DataFrame({
        "id": range(1, 6),
        "cat": ["Compact", "Midsize", "Full-size", "SUV", "Truck"],
        "pre": [20.3, 22.4, 24.5, 26.6, 28.7],
        "post": [25.1, 27.2, 29.3, 31.4, 33.5]
    })

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)
fig.subplots_adjust(left=0.115, right=0.972, bottom=0.177, top=0.745)

y_pos = np.arange(len(db_data))

for y_p, p_pre, p_post in zip(y_pos, db_data["pre"], db_data["post"]):
    ax.plot([p_pre, p_post], [y_p, y_p], color=wildcat_colors["wc_axis"], linewidth=2.0, zorder=2)

ax.scatter(db_data["pre"], y_pos, color=wildcat_colors["nupurple"], s=45, label="Baseline", zorder=3)
ax.scatter(db_data["post"], y_pos, color=wildcat_colors["nudarkorange"], s=45, label="Optimized", zorder=4)

ax.set_yticks(y_pos)
ax.set_yticklabels(db_data["cat"])
ax.set_ylim(-0.5, len(db_data) - 0.5)
ax.set_xlim(19, 35)
ax.set_xticks([20, 25, 30])

legend_top(ax, ncol=2)

labs(
    ax,
    title="Fleet Upgrades: Baseline vs. Optimized",
    subtitle="Fuel efficiency improvements across vehicle segments",
    x="Miles per Gallon (mpg)",
    y="Vehicle Class",
    caption="Source: Engineering Simulation Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_dumbbell.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 11: Histogram with Continuous Density Overlay
# ==============================================================================
fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

price = auto["price"].dropna()

# Histogram matching R geom_histogram(bins=12)
count, bins, _ = ax.hist(
    price,
    bins=12,
    density=True,
    color=wildcat_colors["nupurple"],
    alpha=0.35,
    edgecolor=wildcat_colors["nupurple"],
    linewidth=0.8,
    zorder=2
)

# Overlay density matching R geom_density
bw_price = calc_r_silverman_bw(price)
kde_price = stats.gaussian_kde(price, bw_method=bw_price / price.std(ddof=1))
x_grid = np.linspace(price.min(), price.max(), 200)
ax.plot(x_grid, kde_price(x_grid), color=wildcat_colors["nudarkorange"], linewidth=1.8, zorder=3)

ax.set_xlim(2000, 17000)
ax.set_xticks([4000, 8000, 12000, 16000])
ax.set_ylim(0, 3.6e-4)
ax.set_yticks([0, 1e-4, 2e-4, 3e-4])
ax.set_yticklabels(["0e+00", "1e-04", "2e-04", "3e-04"])

labs(
    ax,
    title="Automobile Price Distribution",
    subtitle="Histogram bins with overlaid continuous kernel density estimate",
    x="Price (USD)",
    y="Density",
    caption="Source: 1978 Automobile Data"
)

plt.savefig(OUTPUT_DIR / "py_histogram.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 12: Bubble Chart with Weighted Markers
# ==============================================================================
fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

dom = auto[auto["foreign"] == 0]
for_data = auto[auto["foreign"] == 1]

# Point area proportional to trunk volume
s_dom = (dom["trunk"] ** 1.8) * 1.5
s_for = (for_data["trunk"] ** 1.8) * 1.5

ax.scatter(
    dom["weight"], dom["mpg"],
    s=s_dom,
    color=wildcat_colors["nupurple"],
    alpha=0.40,
    edgecolors="none",
    label="Domestic",
    zorder=3
)
ax.scatter(
    for_data["weight"], for_data["mpg"],
    s=s_for,
    color=wildcat_colors["nudarkorange"],
    alpha=0.40,
    edgecolors="none",
    label="Foreign",
    zorder=3
)

ax.set_xlim(1700, 4900)
ax.set_xticks([2000, 3000, 4000])
ax.set_ylim(7, 45)
ax.set_yticks([20, 30, 40])

legend_top(ax, ncol=2, markerscale=0.6)

labs(
    ax,
    title="Vehicle Weight, Mileage, and Trunk Capacity",
    subtitle="Weighted scatter with bubble area proportional to trunk volume (cu. ft.)",
    x="Vehicle Weight (lbs.)",
    y="Mileage (mpg)",
    caption="Source: 1978 Automobile Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_bubble.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 13: Empirical Cumulative Distribution Function (ECDF)
# ==============================================================================
fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

dom_sorted = np.sort(dom["mpg"])
dom_ecdf = np.arange(1, len(dom_sorted) + 1) / len(dom_sorted)

for_sorted = np.sort(for_data["mpg"])
for_ecdf = np.arange(1, len(for_sorted) + 1) / len(for_sorted)

# Extend line to margins matching R stat_ecdf
x_dom = np.concatenate([[10], dom_sorted, [43]])
y_dom = np.concatenate([[0], dom_ecdf, [1.0]])

x_for = np.concatenate([[10], for_sorted, [43]])
y_for = np.concatenate([[0], for_ecdf, [1.0]])

ax.step(x_dom, y_dom, where="post", color=wildcat_colors["nupurple"], linewidth=1.8, label="Domestic", zorder=3)
ax.step(x_for, y_for, where="post", color=wildcat_colors["nudarkorange"], linewidth=1.8, label="Foreign", zorder=3)

ax.set_xlim(10, 43)
ax.set_xticks([20, 30, 40])
ax.set_ylim(0, 1.05)
ax.set_yticks(np.arange(0, 1.01, 0.25))
ax.set_yticklabels(["0.00", "0.25", "0.50", "0.75", "1.00"])

legend_top(ax, ncol=2)

labs(
    ax,
    title="Empirical Cumulative Distribution of Mileage",
    subtitle="Cumulative probability comparison between domestic and foreign vehicles",
    x="Mileage (mpg)",
    y="Cumulative Probability (F(x))",
    caption="Source: 1978 Automobile Data",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_ecdf.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 14: Stacked Area Composition Chart
# ==============================================================================
area_path = DATA_DIR / "area.dta"
if area_path.exists():
    a_data = pd.read_stata(area_path)
else:
    years = np.arange(2014, 2024)
    idx = np.arange(1, 11)
    a_data = pd.DataFrame({
        "year": years,
        "s1": 45 - idx * 1.5,
        "s2": 30 + idx * 0.8,
        "s3": 25 + idx * 0.7
    })

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

# In R ggplot2, stacked in order: Conventional, Solar & Wind, Hydroelectric
y_stack = [a_data["s1"], a_data["s2"], a_data["s3"]]
colors = [wildcat_colors["nupurple"], wildcat_colors["nudarkorange"], wildcat_colors["nubrightblue"]]
labels_list = ["Conventional", "Solar & Wind", "Hydroelectric"]

ax.stackplot(
    a_data["year"],
    y_stack,
    labels=labels_list,
    colors=colors,
    alpha=0.60,
    edgecolor="none",
    zorder=2
)

ax.set_xlim(2014, 2023)
ax.set_xticks(np.arange(2014, 2025, 2))
ax.set_ylim(0, 100)
ax.set_yticks(np.arange(0, 101, 20))

legend_top(ax, ncol=3)

labs(
    ax,
    title="Energy Portfolio Composition (2014-2023)",
    subtitle="Relative percentage share of energy production sources",
    x="Year",
    y="Share of Generation (%)",
    caption="Source: Simulated Energy Grid Accounts",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_area.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 15: Uncertainty Fan Chart / Nested Confidence Bands
# ==============================================================================
ribbon_path = DATA_DIR / "ribbon.dta"
if ribbon_path.exists():
    r_data = pd.read_stata(ribbon_path)
else:
    years = np.arange(2020, 2031)
    t = np.arange(0, 11)
    fc = 100 * np.exp(0.06 * t)
    r_data = pd.DataFrame({
        "year": years,
        "fc": fc,
        "lo80": fc - 3.5 * np.sqrt(t),
        "hi80": fc + 3.5 * np.sqrt(t),
        "lo95": fc - 6.2 * np.sqrt(t),
        "hi95": fc + 6.2 * np.sqrt(t)
    })

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)

# 80% Interval (alpha = 0.30)
p80 = ax.fill_between(
    r_data["year"], r_data["lo80"], r_data["hi80"],
    color=wildcat_colors["nupurple"], alpha=0.30, edgecolor="none", label="80% Interval", zorder=3
)
# 95% Interval (alpha = 0.15)
p95 = ax.fill_between(
    r_data["year"], r_data["lo95"], r_data["hi95"],
    color=wildcat_colors["nupurple"], alpha=0.15, edgecolor="none", label="95% Interval", zorder=2
)
# Point Forecast line
l_fc = ax.plot(r_data["year"], r_data["fc"], color=wildcat_colors["nupurple"], linewidth=1.8, label="Point Forecast", zorder=4)[0]

ax.set_xticks(np.arange(2020, 2031, 2))
ax.set_xlim(2020, 2030)
ax.set_ylim(90, 210)
ax.set_yticks([100, 125, 150, 175, 200])

# Match R legend order: 80% Interval, 95% Interval, Point Forecast
legend_top(ax, ncol=3, handles=[p80, p95, l_fc], labels=["80% Interval", "95% Interval", "Point Forecast"])

labs(
    ax,
    title="Economic Output Projection with Confidence Bands",
    subtitle="Baseline forecast with nested 80% and 95% uncertainty intervals",
    x="Forecast Horizon (Year)",
    y="Index Value (2020 = 100)",
    caption="Source: Macroeconomic Forecasting Model",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_ribbon.png", dpi=DPI)
plt.close(fig)


# ==============================================================================
# Plot 16: Bi-Directional / Tornado Bar Chart
# ==============================================================================
pyramid_path = DATA_DIR / "pyramid.dta"
if pyramid_path.exists():
    pyr_data = pd.read_stata(pyramid_path)
else:
    pyr_data = pd.DataFrame({
        "id": range(1, 7),
        "metric": ["Q1 Sales", "Q2 Margin", "Q3 Volume", "Q4 Growth", "FY EBITDA", "FCF Yield"],
        "pos": [13.5, 0, 20.5, 0, 27.5, 0],
        "neg": [0, -13.6, 0, -19.2, 0, -24.8]
    })

pyr_data["val"] = np.where(pyr_data["pos"] > 0, pyr_data["pos"], pyr_data["neg"])

fig, ax = plt.subplots(figsize=(PLOT_W, PLOT_H), dpi=DPI)
fig.subplots_adjust(left=0.127, right=0.972, bottom=0.177, top=0.745)

ax.axvline(0, color=wildcat_colors["wc_axis"], linewidth=0.8, zorder=2)

y_pos = np.arange(len(pyr_data))[::-1]
colors = [wildcat_colors["nupurple"] if v > 0 else wildcat_colors["nudarkorange"] for v in pyr_data["val"]]

ax.barh(y_pos, pyr_data["val"], height=0.58, color=colors, edgecolor="none", zorder=3)

ax.set_yticks(y_pos)
ax.set_yticklabels(pyr_data["metric"])
ax.set_ylim(-0.6, len(pyr_data) - 0.4)
ax.set_xlim(-28, 32)
ax.set_xticks([-20, -10, 0, 10, 20, 30])

# Gridlines on X only
ax.xaxis.grid(True, color=wildcat_colors["wc_grid"], linewidth=0.8, zorder=1)
ax.yaxis.grid(False)

# Custom legend
p_patch = plt.Rectangle((0, 0), 1, 1, color=wildcat_colors["nupurple"], label="Favorable (Surplus)")
n_patch = plt.Rectangle((0, 0), 1, 1, color=wildcat_colors["nudarkorange"], label="Unfavorable (Deficit)")
legend_top(ax, handles=[p_patch, n_patch], labels=["Favorable (Surplus)", "Unfavorable (Deficit)"], ncol=2)

labs(
    ax,
    title="Quarterly Performance Variances vs. Budget",
    subtitle="Percentage variance across operational and financial metrics",
    x="Variance from Budget (%)",
    y="Performance Metric",
    caption="Source: Financial Planning & Analysis Report",
    top_legend=True
)

plt.savefig(OUTPUT_DIR / "py_pyramid.png", dpi=DPI)
plt.close(fig)

print("All 16 Python test plots exported successfully to output_checks/")
