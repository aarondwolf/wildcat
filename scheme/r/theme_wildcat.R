# ==============================================================================
# theme_wildcat.R
# Wildcat Graph Styling & Northwestern University Brand Color System
# Synchronized with Stata scheme-wildcat
# ==============================================================================

library(ggplot2)

# ------------------------------------------------------------------------------
# 1. Northwestern University Brand Colors & Wildcat Theme Elements
# ------------------------------------------------------------------------------
wildcat_colors <- c(
  # Primary Brand Colors (Official Northwestern University Palette)
  # Reference: https://www.northwestern.edu/brand/
  nupurple        = "#4E2A84", # RGB: 78 42 132  - Primary Northwestern Purple
  nupurple150     = "#260841", # RGB: 38 8 65    - Deep Purple
  nupurple50      = "#9380C0", # RGB: 147 128 192 - Light Purple
  nupurple40      = "#A495C3", # RGB: 164 149 195 - Muted Tint
  nupurple20      = "#CCC4DF", # RGB: 204 196 223 - Soft Tint
  
  # Secondary Palette (Bright)
  nubrightgreen   = "#58B9AB", # RGB: 88 185 171
  nubrightteal    = "#7FCECD", # RGB: 127 206 205
  nubrightblue    = "#5091CD", # RGB: 80 145 205
  nubrightyellow  = "#EDE93B", # RGB: 237 233 59
  nubrightorange  = "#FFC520", # RGB: 255 197 32
  nubrightred     = "#EF553F", # RGB: 239 85 63
  
  # Secondary Palette (Dark)
  nudarkgreen     = "#008656", # RGB: 0 134 86
  nudarkteal      = "#007FA4", # RGB: 0 127 164
  nudarkblue      = "#0D2D6C", # RGB: 13 45 108
  nudarkyellow    = "#D9C826", # RGB: 217 200 38
  nudarkorange    = "#CA7C1B", # RGB: 202 124 27
  nudarkred       = "#D85820", # RGB: 216 88 32
  
  # Brand Neutral
  nurichblack     = "#000000", # RGB: 0 0 0
  
  # Wildcat Theme Structural & Semantic Colors
  # Note on Stata built-in color proximity:
  #   wc_bg    (#FFFFFF) is identical to Stata's white / gs16
  #   wc_axis  (#CCCCCC) is very close to Stata's gs13 (RGB: 208 208 208)
  #   wc_grid  (#EAEAEA) is close to Stata's dimgray (232 232 232) / gs15 (240 240 240)
  #   wc_title (#222222) is close to Stata's gs2 (RGB: 32 32 32)
  #   wc_body  (#666666) is close to Stata's gs6 (RGB: 96 96 96)
  wc_bg           = "#FFFFFF", # Pure white canvas
  wc_title        = "#222222", # Dark charcoal for headings and titles
  wc_body         = "#666666", # Medium muted gray for subtitles, captions, ticks
  wc_grid         = "#EAEAEA", # Thin light gray horizontal gridlines
  wc_axis         = "#CCCCCC"  # Subtle axis baseline and ticks
)

# Backwards compatibility alias
nu_colors <- wildcat_colors

# ------------------------------------------------------------------------------
# 2. Palette Definitions
# ------------------------------------------------------------------------------
# Default categorical sequence mapped for maximum contrast and accessibility
wildcat_palettes <- list(
  default = unname(wildcat_colors[c(
    "nupurple",        # plot1
    "nudarkorange",    # plot2
    "nubrightblue",    # plot3
    "nudarkgreen",     # plot4
    "nubrightorange",  # plot5
    "nubrightteal",    # plot6
    "nubrightred",     # plot7
    "nudarkblue",      # plot8
    "nudarkteal",      # plot9
    "nubrightgreen",   # plot10
    "nudarkyellow",    # plot11
    "nupurple50"       # plot12
  )]),
  
  purple = unname(wildcat_colors[c(
    "nupurple150",
    "nupurple",
    "nupurple50",
    "nupurple40",
    "nupurple20"
  )]),
  
  bright = unname(wildcat_colors[c(
    "nupurple",
    "nudarkorange",
    "nubrightblue",
    "nubrightgreen",
    "nubrightteal",
    "nubrightorange",
    "nubrightred",
    "nubrightyellow"
  )]),
  
  dark = unname(wildcat_colors[c(
    "nupurple150",
    "nudarkorange",
    "nudarkblue",
    "nudarkteal",
    "nudarkgreen",
    "nudarkred",
    "nudarkyellow"
  )]),
  
  two_color = unname(wildcat_colors[c(
    "nupurple",
    "nudarkorange"
  )])
)

nu_palettes <- wildcat_palettes

# ------------------------------------------------------------------------------
# 3. Palette Generator & Scale Helpers
# ------------------------------------------------------------------------------
#' Generate Wildcat Color Palette Function
#'
#' @param palette Name of palette in `wildcat_palettes` (default: "default")
#' @param reverse Logical indicating whether to reverse the palette order
#' @return A function that takes integer n and returns n hex colors
wildcat_palette <- function(palette = "default", reverse = FALSE) {
  pal <- wildcat_palettes[[palette]]
  if (is.null(pal)) {
    stop(sprintf("Palette '%s' not found. Available: %s",
                 palette, paste(names(wildcat_palettes), collapse = ", ")))
  }
  if (reverse) pal <- rev(pal)
  
  function(n) {
    if (n <= length(pal)) {
      pal[seq_len(n)]
    } else {
      grDevices::colorRampPalette(pal)(n)
    }
  }
}

nu_palette <- wildcat_palette

#' Wildcat Discrete/Continuous Color Scale
#'
#' @param palette Palette name ("default", "purple", "bright", "dark", "two_color")
#' @param discrete Logical, TRUE for discrete data, FALSE for continuous gradient
#' @param reverse Logical, reverse color sequence
#' @param ... Additional arguments passed to discrete_scale or scale_color_gradientn
#' @export
scale_color_wildcat <- function(palette = "default", discrete = TRUE, reverse = FALSE, ...) {
  pal <- wildcat_palette(palette = palette, reverse = reverse)
  if (discrete) {
    discrete_scale(aesthetics = "colour", palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}

#' British spelling alias for scale_color_wildcat
#' @export
scale_colour_wildcat <- scale_color_wildcat

#' Backwards compatibility aliases for scale_color_nu
#' @export
scale_color_nu <- scale_color_wildcat
scale_colour_nu <- scale_color_wildcat

#' Wildcat Discrete/Continuous Fill Scale
#'
#' @param palette Palette name ("default", "purple", "bright", "dark", "two_color")
#' @param discrete Logical, TRUE for discrete data, FALSE for continuous gradient
#' @param reverse Logical, reverse color sequence
#' @param ... Additional arguments passed to discrete_scale or scale_fill_gradientn
#' @export
scale_fill_wildcat <- function(palette = "default", discrete = TRUE, reverse = FALSE, ...) {
  pal <- wildcat_palette(palette = palette, reverse = reverse)
  if (discrete) {
    discrete_scale(aesthetics = "fill", palette = pal, ...)
  } else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}

#' Backwards compatibility alias for scale_fill_nu
#' @export
scale_fill_nu <- scale_fill_wildcat

# ------------------------------------------------------------------------------
# 4. Custom theme_wildcat() extending theme_minimal()
# ------------------------------------------------------------------------------
#' Wildcat Publication-Grade ggplot2 Theme
#'
#' Synchronized with Stata's scheme-wildcat
#'
#' @param base_size Base font size in points (default: 11)
#' @param base_family Base font family (default: "sans")
#' @return A ggplot2 theme object
#' @export
theme_wildcat <- function(base_size = 11, base_family = "sans") {
  theme_minimal(base_size = base_size, base_family = base_family) +
    theme(
      # Canvas & Background: pure white, zero outer box, zero inner frame
      plot.background = element_rect(fill = wildcat_colors[["wc_bg"]], color = NA),
      panel.background = element_rect(fill = wildcat_colors[["wc_bg"]], color = NA),
      panel.border = element_blank(),
      
      # Typography & Hierarchy:
      # Dark charcoal titles (#222222), muted medium gray numbers and notes (#666666)
      plot.title = element_text(
        color = wildcat_colors[["wc_title"]],
        face = "bold",
        size = rel(1.30),
        hjust = 0,
        margin = margin(t = 2, b = 4)
      ),
      plot.subtitle = element_text(
        color = wildcat_colors[["wc_body"]],
        face = "plain",
        size = rel(0.98),
        hjust = 0,
        margin = margin(b = 10)
      ),
      plot.caption = element_text(
        color = wildcat_colors[["wc_body"]],
        face = "plain",
        size = rel(0.82),
        hjust = 0,
        margin = margin(t = 12, b = 2)
      ),
      
      # Axes:
      # X-axis has subtle baseline (#CCCCCC) and tick marks; Y-axis has NO line and NO ticks
      axis.line.x = element_line(color = wildcat_colors[["wc_axis"]], linewidth = 0.35),
      axis.line.y = element_blank(),
      axis.ticks.x = element_line(color = wildcat_colors[["wc_axis"]], linewidth = 0.35),
      axis.ticks.y = element_blank(),
      axis.ticks.length = unit(3.5, "pt"),
      axis.title.x = element_text(
        color = wildcat_colors[["wc_title"]],
        face = "plain",
        size = rel(0.95),
        margin = margin(t = 3, b = 2)
      ),
      axis.title.y = element_text(
        color = wildcat_colors[["wc_title"]],
        face = "plain",
        size = rel(0.95),
        margin = margin(r = 4, l = 2)
      ),
      axis.text.x = element_text(
        color = wildcat_colors[["wc_body"]],
        face = "plain",
        size = rel(0.85),
        margin = margin(t = 2)
      ),
      axis.text.y = element_text(
        color = wildcat_colors[["wc_body"]],
        face = "plain",
        size = rel(0.85),
        margin = margin(r = 2)
      ),
      
      # Gridlines: Horizontal gridlines ON (#EAEAEA), Vertical gridlines OFF
      panel.grid.major.y = element_line(color = wildcat_colors[["wc_grid"]], linewidth = 0.45),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      
      # Facet Strips: Bold header (#222222) with zero banner background
      strip.background = element_blank(),
      strip.text = element_text(
        color = wildcat_colors[["wc_title"]],
        face = "bold",
        size = rel(1.05),
        margin = margin(t = 4, b = 8)
      ),
      
      # Legend: Borderless, horizontal layout placed at top-left
      legend.position = "top",
      legend.justification = "left",
      legend.direction = "horizontal",
      legend.background = element_blank(),
      legend.box.background = element_blank(),
      legend.title = element_text(
        color = wildcat_colors[["wc_title"]],
        face = "bold",
        size = rel(0.90)
      ),
      legend.text = element_text(
        color = wildcat_colors[["wc_body"]],
        face = "plain",
        size = rel(0.85)
      ),
      legend.key = element_blank(),
      legend.key.size = unit(12, "pt"),
      legend.spacing.x = unit(4, "pt"),
      legend.margin = margin(t = 0, b = 4, l = 0, r = 0),
      legend.box.spacing = unit(4, "pt"),
      
      # Overall Plot Margins (Top, Right, Bottom, Left)
      plot.margin = margin(t = 12, r = 16, b = 12, l = 14)
    )
}

#' Backwards compatibility alias for theme_nu
#' @export
theme_nu <- theme_wildcat
