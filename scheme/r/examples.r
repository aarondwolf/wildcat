# ==============================================================================
# examples.r
# Comprehensive Demonstration Suite for Wildcat R ggplot2 Theme (theme_wildcat)
# Generates 16 synchronized, publication-grade chart types matching Stata & Python
# ==============================================================================

# Resolve root scheme directory regardless of invocation working directory
find_scheme_dir <- function() {
  if (dir.exists("r") && dir.exists("data") && file.exists("r/theme_wildcat.R")) {
    return(".")
  }
  if (dir.exists("../data") && file.exists("theme_wildcat.R")) {
    return("..")
  }
  if (dir.exists("scheme/r") && dir.exists("scheme/data") && file.exists("scheme/r/theme_wildcat.R")) {
    return("scheme")
  }
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg) > 0) {
    script_dir <- dirname(normalizePath(sub("^--file=", "", file_arg[1])))
    if (basename(script_dir) == "r") {
      return(normalizePath(dirname(script_dir)))
    }
  }
  return(".")
}

scheme_dir <- find_scheme_dir()
source(file.path(scheme_dir, "r", "theme_wildcat.R"))

data_dir <- file.path(scheme_dir, "data")
output_dir <- file.path(scheme_dir, "output_checks")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Standard image export dimensions (8" x 5" at 300 DPI = 2400 x 1500 px)
plot_w <- 8
plot_h <- 5
plot_dpi <- 300

# Helper to read .dta datasets
read_dta_safe <- function(filename) {
  p <- file.path(data_dir, filename)
  if (!file.exists(p)) {
    stop("Dataset '", filename, "' not found at ", p, ".\nPlease ensure scheme/data/ is populated.")
  }
  if (!requireNamespace("haven", quietly = TRUE)) {
    stop("The 'haven' package is required to read .dta files. Please install it via install.packages('haven').")
  }
  haven::read_dta(p)
}

# Load shared auto dataset
auto <- read_dta_safe("auto.dta")
rating_names <- c("Poor (1)", "Fair (2)", "Average (3)", "Good (4)", "Excellent (5)")

# ------------------------------------------------------------------------------
# Plot 1: Scatter plot with linear fit & 95% CI ribbon
# ------------------------------------------------------------------------------
p1 <- ggplot(auto, aes(x = weight, y = mpg)) +
  geom_smooth(
    method = "lm",
    formula = y ~ x,
    color = nu_colors[["nupurple"]],
    fill = nu_colors[["nupurple20"]],
    linewidth = 0.85,
    alpha = 1.0
  ) +
  geom_point(
    color = nu_colors[["nupurple"]],
    size = 2.0,
    alpha = 0.90
  ) +
  labs(
    title = "Automobile Weight vs. Fuel Efficiency",
    subtitle = "Linear fit with 95% confidence ribbon",
    x = "Vehicle Weight (lbs.)",
    y = "Mileage (mpg)",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_scatter.png"), p1, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 2: Horizontal bar chart across repair categories
# ------------------------------------------------------------------------------
auto_agg <- aggregate(mpg ~ rep78, data = auto, FUN = mean)
auto_agg$rep78_axis <- factor(auto_agg$rep78, levels = rev(1:5), labels = rev(rating_names))
auto_agg$rep78_fill <- factor(rating_names[auto_agg$rep78], levels = rating_names)

p2 <- ggplot(auto_agg, aes(x = rep78_axis, y = mpg, fill = rep78_fill)) +
  geom_col(width = 0.58) +
  coord_flip() +
  scale_fill_nu(name = NULL, breaks = rating_names) +
  scale_y_continuous(breaks = seq(0, 30, by = 10), limits = c(0, 30), expand = expansion(mult = c(0, 0.05))) +
  labs(
    title = "Average Fuel Efficiency by Repair Record",
    subtitle = "Mean miles per gallon across 1978 repair ratings",
    x = NULL,
    y = "Mean Mileage (mpg)",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#EAEAEA", linewidth = 0.4),
    axis.line.y = element_blank(),
    axis.line.x = element_line(color = "#CCCCCC", linewidth = 0.4),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.ticks.x = element_line(color = "#CCCCCC", linewidth = 0.4)
  )

# ggsave(file.path(output_dir, "r_bar.png"), p2, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 3: Multi-panel faceted plot (by origin)
# ------------------------------------------------------------------------------
auto$origin <- factor(auto$foreign, levels = c(0, 1), labels = c("Domestic", "Foreign"))

p3 <- ggplot(auto, aes(x = weight, y = mpg, color = origin)) +
  geom_point(size = 2.0, alpha = 0.90) +
  facet_wrap(~ origin) +
  scale_color_nu(name = NULL) +
  labs(
    title = "Mileage vs. Weight by Vehicle Origin",
    subtitle = "Comparison of Domestic vs. Foreign automobiles",
    x = "Vehicle Weight (lbs.)",
    y = "Mileage (mpg)",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat() +
  theme(legend.position = "none")

# ggsave(file.path(output_dir, "r_facet.png"), p3, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 4: Box plot across repair records
# ------------------------------------------------------------------------------
auto_box <- auto[!is.na(auto$rep78), ]
auto_box$rep78_factor <- factor(auto_box$rep78, levels = 1:5, labels = rating_names)

p4 <- ggplot(auto_box, aes(x = rep78_factor, y = mpg, fill = rep78_factor, color = rep78_factor)) +
  geom_boxplot(width = 0.55, alpha = 0.40, linewidth = 0.75, outlier.size = 1.8) +
  scale_fill_nu(name = NULL, breaks = rating_names) +
  scale_color_nu(name = NULL, breaks = rating_names) +
  labs(
    title = "Fuel Efficiency Distribution by Repair Record",
    subtitle = "Distribution of miles per gallon across 1978 repair ratings",
    x = NULL,
    y = "Mileage (mpg)",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank()
  )

# ggsave(file.path(output_dir, "r_box.png"), p4, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 5: Multi-line time series plot (Industry Performance Trends)
# ------------------------------------------------------------------------------
trends_path <- file.path(data_dir, "trends.dta")
if (file.exists(trends_path)) {
  trends <- haven::read_dta(trends_path)
} else {
  years <- 2010:2022
  idx <- 1:13
  trends <- data.frame(
    year = years,
    tech = round(100 * exp(0.088 * (idx - 1)) + 1.8 * sin(idx * 0.9), 1),
    health = round(100 * exp(0.055 * (idx - 1)) + 1.2 * cos(idx * 0.9), 1),
    energy = round(100 * exp(0.032 * (idx - 1)) + 2.5 * sin(idx * 1.5), 1)
  )
}

trends_long <- data.frame(
  year = rep(trends$year, 3),
  sector = factor(rep(c("Technology", "Healthcare", "Energy"), each = nrow(trends)),
                  levels = c("Technology", "Healthcare", "Energy")),
  index_val = c(trends$tech, trends$health, trends$energy)
)

p5 <- ggplot(trends_long, aes(x = year, y = index_val, color = sector)) +
  geom_line(linewidth = 0.85) +
  scale_color_nu(name = NULL) +
  scale_x_continuous(breaks = c(2010, 2015, 2020, 2025)) +
  labs(
    title = "Industry Performance Trends (2010-2022)",
    subtitle = "Normalized cumulative sector growth index (Base = 100)",
    x = "Year",
    y = "Index Value (2010 = 100)",
    caption = "Source: Simulated Market Index Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_line.png"), p5, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 6: Kernel density distribution plot
# ------------------------------------------------------------------------------
p6 <- ggplot(auto, aes(x = mpg, fill = origin, color = origin)) +
  geom_density(alpha = 0.25, linewidth = 0.85) +
  scale_fill_nu(name = NULL) +
  scale_color_nu(name = NULL) +
  labs(
    title = "Fuel Efficiency Density by Origin",
    subtitle = "Kernel density estimates for domestic vs. foreign automobiles",
    x = "Mileage (mpg)",
    y = "Density",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_density.png"), p6, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 7: Cleveland Dot Plot
# ------------------------------------------------------------------------------
p7 <- ggplot(auto_agg, aes(x = rep78_axis, y = mpg, color = rep78_fill)) +
  geom_segment(aes(x = rep78_axis, xend = rep78_axis, y = 0, yend = mpg),
               linetype = "dotted", color = "#CCCCCC", linewidth = 0.5) +
  geom_point(size = 3.5) +
  coord_flip() +
  scale_color_nu(name = NULL, breaks = rating_names) +
  scale_y_continuous(breaks = seq(0, 30, by = 10), limits = c(0, 30), expand = expansion(mult = c(0, 0.05))) +
  labs(
    title = "Mean Fuel Efficiency by Repair Record",
    subtitle = "Cleveland dot plot across repair ratings",
    x = NULL,
    y = "Miles per Gallon (mpg)",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#EAEAEA", linewidth = 0.4),
    axis.line.y = element_blank(),
    axis.line.x = element_line(color = "#CCCCCC", linewidth = 0.4),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.ticks.x = element_line(color = "#CCCCCC", linewidth = 0.4)
  )

# ggsave(file.path(output_dir, "r_dot.png"), p7, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 8: Lollipop / Stem Plot
# ------------------------------------------------------------------------------
lollipop_path <- file.path(data_dir, "lollipop.dta")
if (file.exists(lollipop_path)) {
  lpop <- haven::read_dta(lollipop_path)
} else {
  mean_mpg <- mean(auto_agg$mpg)
  lpop <- data.frame(rep78 = auto_agg$rep78, diff = round(auto_agg$mpg - mean_mpg, 1))
}

p8 <- ggplot(lpop, aes(x = rep78, y = diff)) +
  geom_hline(yintercept = 0, color = "#CCCCCC", linetype = "dashed", linewidth = 0.4) +
  geom_segment(aes(x = rep78, xend = rep78, y = 0, yend = diff),
               color = nu_colors[["nupurple"]], linewidth = 0.85) +
  geom_point(color = nu_colors[["nupurple"]], size = 3.5) +
  scale_x_continuous(breaks = 1:5) +
  labs(
    title = "Mileage Deviation by Repair Rating",
    subtitle = "Difference from overall mean repair rating efficiency",
    x = "Repair Record (1-5)",
    y = "Deviation from Mean (mpg)",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_lollipop.png"), p8, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 9: Coefficient / Forest Plot
# ------------------------------------------------------------------------------
forest_path <- file.path(data_dir, "forest.dta")
if (file.exists(forest_path)) {
  f_data <- haven::read_dta(forest_path)
} else {
  f_data <- data.frame(
    id = 1:4,
    parm = c("Weight (lbs)", "Displacement", "Gear Ratio", "Foreign Origin"),
    b = c(-0.005, -0.012, 1.450, 2.130),
    min95 = c(-0.007, -0.018, 0.900, 1.410),
    max95 = c(-0.003, -0.006, 2.000, 2.850)
  )
}
f_data$parm_factor <- factor(f_data$parm, levels = f_data$parm)

p9 <- ggplot(f_data, aes(y = parm_factor, x = b, xmin = min95, xmax = max95)) +
  geom_vline(xintercept = 0, color = "#CCCCCC", linetype = "dashed", linewidth = 0.4) +
  geom_errorbar(height = 0.25, color = nu_colors[["nupurple"]], linewidth = 0.85) +
  geom_point(color = nu_colors[["nupurple"]], size = 2.5) +
  labs(
    title = "Regression Coefficient Estimates (95% CI)",
    subtitle = "Marginal effects on vehicle fuel efficiency",
    x = "Estimated Coefficient",
    y = "Model Parameter",
    caption = "Source: OLS Specification Estimates"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_forest.png"), p9, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 10: Dumbbell / Paired Comparison Plot
# ------------------------------------------------------------------------------
dumbbell_path <- file.path(data_dir, "dumbbell.dta")
if (file.exists(dumbbell_path)) {
  db_data <- haven::read_dta(dumbbell_path)
} else {
  db_data <- data.frame(
    id = 1:5,
    cat = c("Compact", "Midsize", "Full-size", "SUV", "Truck"),
    pre = c(20.3, 22.4, 24.5, 26.6, 28.7),
    post = c(25.1, 27.2, 29.3, 31.4, 33.5)
  )
}
db_data$cat_factor <- factor(db_data$cat, levels = db_data$cat)

p10 <- ggplot(db_data, aes(y = cat_factor)) +
  geom_segment(aes(x = pre, xend = post, y = cat_factor, yend = cat_factor),
               color = "#CCCCCC", linewidth = 0.85) +
  geom_point(aes(x = pre, color = "Baseline"), size = 2.5) +
  geom_point(aes(x = post, color = "Optimized"), size = 2.5) +
  scale_color_manual(name = NULL,
                     values = c("Baseline" = unname(nu_colors["nupurple"]),
                                "Optimized" = unname(nu_colors["nudarkorange"]))) +
  labs(
    title = "Fleet Upgrades: Baseline vs. Optimized",
    subtitle = "Fuel efficiency improvements across vehicle segments",
    x = "Miles per Gallon (mpg)",
    y = "Vehicle Class",
    caption = "Source: Engineering Simulation Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_dumbbell.png"), p10, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 11: Histogram with Continuous Density Overlay
# ------------------------------------------------------------------------------
p11 <- ggplot(auto, aes(x = price)) +
  geom_histogram(aes(y = after_stat(density)), bins = 12,
                 fill = "#4E2A84", alpha = 0.35, color = "#4E2A84", linewidth = 0.3) +
  geom_density(color = "#CA7C1B", linewidth = 0.85) +
  labs(
    title = "Automobile Price Distribution",
    subtitle = "Histogram bins with overlaid continuous kernel density estimate",
    x = "Price (USD)",
    y = "Density",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_histogram.png"), p11, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 12: Bubble Chart with Weighted Markers
# ------------------------------------------------------------------------------
p12 <- ggplot(auto, aes(x = weight, y = mpg, size = trunk, color = origin, fill = origin)) +
  geom_point(alpha = 0.40) +
  scale_size_continuous(range = c(2, 9), name = "Trunk Space") +
  scale_color_nu(name = NULL) +
  scale_fill_nu(name = NULL) +
  guides(size = "none") +
  labs(
    title = "Vehicle Weight, Mileage, and Trunk Capacity",
    subtitle = "Weighted scatter with bubble area proportional to trunk volume (cu. ft.)",
    x = "Vehicle Weight (lbs.)",
    y = "Mileage (mpg)",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_bubble.png"), p12, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 13: Empirical Cumulative Distribution Function (ECDF)
# ------------------------------------------------------------------------------
p13 <- ggplot(auto, aes(x = mpg, color = origin)) +
  stat_ecdf(geom = "step", linewidth = 0.85) +
  scale_color_nu(name = NULL) +
  scale_y_continuous(breaks = seq(0, 1, 0.25), limits = c(0, 1)) +
  labs(
    title = "Empirical Cumulative Distribution of Mileage",
    subtitle = "Cumulative probability comparison between domestic and foreign vehicles",
    x = "Mileage (mpg)",
    y = "Cumulative Probability (F(x))",
    caption = "Source: 1978 Automobile Data"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_ecdf.png"), p13, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 14: Stacked Area Composition Chart
# ------------------------------------------------------------------------------
area_path <- file.path(data_dir, "area.dta")
if (file.exists(area_path)) {
  a_data <- haven::read_dta(area_path)
} else {
  years <- 2014:2023
  idx <- 1:10
  a_data <- data.frame(
    year = years,
    s1 = 45 - idx * 1.5,
    s2 = 30 + idx * 0.8,
    s3 = 25 + idx * 0.7
  )
}

a_long <- data.frame(
  year = rep(a_data$year, 3),
  sector = factor(rep(c("Conventional", "Solar & Wind", "Hydroelectric"), each = nrow(a_data)),
                  levels = c("Conventional", "Solar & Wind", "Hydroelectric")),
  share = c(a_data$s1, a_data$s2, a_data$s3)
)

p14 <- ggplot(a_long, aes(x = year, y = share, fill = sector)) +
  geom_area(alpha = 0.60, position = position_stack(reverse = TRUE)) +
  scale_fill_nu(name = NULL) +
  scale_x_continuous(breaks = seq(2014, 2024, by = 2)) +
  scale_y_continuous(breaks = seq(0, 100, by = 20), limits = c(0, 100)) +
  labs(
    title = "Energy Portfolio Composition (2014-2023)",
    subtitle = "Relative percentage share of energy production sources",
    x = "Year",
    y = "Share of Generation (%)",
    caption = "Source: Simulated Energy Grid Accounts"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_area.png"), p14, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 15: Uncertainty Fan Chart / Nested Confidence Bands
# ------------------------------------------------------------------------------
ribbon_path <- file.path(data_dir, "ribbon.dta")
if (file.exists(ribbon_path)) {
  r_data <- haven::read_dta(ribbon_path)
} else {
  years <- 2020:2030
  t <- 0:10
  fc <- 100 * exp(0.06 * t)
  r_data <- data.frame(
    year = years,
    fc = fc,
    lo80 = fc - 3.5 * sqrt(t),
    hi80 = fc + 3.5 * sqrt(t),
    lo95 = fc - 6.2 * sqrt(t),
    hi95 = fc + 6.2 * sqrt(t)
  )
}

p15 <- ggplot(r_data, aes(x = year)) +
  geom_ribbon(aes(ymin = lo95, ymax = hi95, fill = "95% Interval"), alpha = 0.15) +
  geom_ribbon(aes(ymin = lo80, ymax = hi80, fill = "80% Interval"), alpha = 0.30) +
  geom_line(aes(y = fc, color = "Point Forecast"), linewidth = 0.85) +
  scale_fill_manual(name = NULL, values = c("95% Interval" = "#4E2A84", "80% Interval" = "#4E2A84"),
                    breaks = c("Point Forecast", "80% Interval", "95% Interval")) +
  scale_color_manual(name = NULL, values = c("Point Forecast" = "#4E2A84")) +
  scale_x_continuous(breaks = seq(2020, 2030, by = 2)) +
  labs(
    title = "Economic Output Projection with Confidence Bands",
    subtitle = "Baseline forecast with nested 80% and 95% uncertainty intervals",
    x = "Forecast Horizon (Year)",
    y = "Index Value (2020 = 100)",
    caption = "Source: Macroeconomic Forecasting Model"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_ribbon.png"), p15, width = plot_w, height = plot_h, dpi = plot_dpi)

# ------------------------------------------------------------------------------
# Plot 16: Bi-Directional / Tornado Bar Chart
# ------------------------------------------------------------------------------
pyramid_path <- file.path(data_dir, "pyramid.dta")
if (file.exists(pyramid_path)) {
  pyr_data <- haven::read_dta(pyramid_path)
} else {
  pyr_data <- data.frame(
    id = 1:6,
    metric = c("Q1 Sales", "Q2 Margin", "Q3 Volume", "Q4 Growth", "FY EBITDA", "FCF Yield"),
    pos = c(13.5, 0, 20.5, 0, 27.5, 0),
    neg = c(0, -13.6, 0, -19.2, 0, -24.8)
  )
}
pyr_data$val <- ifelse(pyr_data$pos > 0, pyr_data$pos, pyr_data$neg)
pyr_data$direction <- ifelse(pyr_data$val > 0, "Favorable (Surplus)", "Unfavorable (Deficit)")
pyr_data$metric_factor <- factor(pyr_data$metric, levels = rev(pyr_data$metric))

p16 <- ggplot(pyr_data, aes(x = val, y = metric_factor, fill = direction)) +
  geom_vline(xintercept = 0, color = "#CCCCCC", linewidth = 0.4) +
  geom_col(width = 0.58) +
  scale_fill_manual(name = NULL,
                    values = c("Favorable (Surplus)" = unname(nu_colors["nupurple"]),
                               "Unfavorable (Deficit)" = unname(nu_colors["nudarkorange"]))) +
  labs(
    title = "Quarterly Performance Variances vs. Budget",
    subtitle = "Percentage variance across operational and financial metrics",
    x = "Variance from Budget (%)",
    y = "Performance Metric",
    caption = "Source: Financial Planning & Analysis Report"
  ) +
  theme_wildcat()

# ggsave(file.path(output_dir, "r_pyramid.png"), p16, width = plot_w, height = plot_h, dpi = plot_dpi)

cat("All 16 R example plots created successfully.\n")
