* ==============================================================================
* make_scheme_mytheme.do
* Custom Stata Scheme Generator Template
* Modern Stata graph scheme synchronized with R ggplot2 (theme_minimal)
* Based on grstyle (Ben Jann)
*
* QUICK START:
*   1. (Optional) Customize the scheme name or boilerplate colors below.
*   2. Run this do-file in Stata (`do make_scheme_mytheme.do`).
*   3. It will generate `scheme-mytheme.scheme` and all `color-*.style` files
*      directly in this folder.
*   4. Install locally using:
*        net from "`c(pwd)'"
*        net install mytheme, replace
*        set scheme mytheme, permanently
* ==============================================================================

version 16.0
set more off

* ------------------------------------------------------------------------------
* USER CONFIGURATION & CUSTOMIZATION SECTION
* ------------------------------------------------------------------------------
local scheme_name       "mytheme"        // Scheme identifier: compiles scheme-`scheme_name'.scheme
local scheme_title      "MyTheme"        // Descriptive display title
local make_color_styles 1                // 1 = write color-*.style files, 0 = skip

* Destination directory defaults to current working directory (where this do-file is executed)
local root "."

* ------------------------------------------------------------------------------
* 1. Check and Install Required Stata Packages
* ------------------------------------------------------------------------------
foreach pkg in grstyle palettes colrspace {
    capture which `pkg'
    if _rc != 0 {
        di as txt "Installing required dependency from SSC: `pkg'..."
        capture ssc install `pkg', replace
    }
}

* ------------------------------------------------------------------------------
* 2. Palette Colors & Theme Structural Elements
* ------------------------------------------------------------------------------
* Boilerplate Custom Colors (RGB: 0 to 255)
* Replace these with your organization's brand colors or your personal preferences:
local customcolor1      "52 101 164"     // #3465A4 - Steel Blue (Primary Accent)
local customcolor2      "245 121 0"      // #F57900 - Warm Orange
local customcolor3      "115 210 22"     // #73D216 - Fresh Green
local customcolor4      "117 80 123"     // #75507B - Muted Plum
local customcolor5      "193 125 17"     // #C17D11 - Bronze / Ochre
local customcolor6      "204 0 0"        // #CC0000 - Crimson Red
local customcolor7      "6 152 154"      // #06989A - Dark Teal
local customcolor8      "85 87 83"       // #555753 - Slate Charcoal

* Structural Canvas & Semantic Colors (calibrated to match R ggplot2 defaults)
local wc_bg             "255 255 255"    // Pure white canvas (#FFFFFF)
local wc_title          "34 34 34"       // Dark charcoal for titles and headings (#222222)
local wc_body           "102 102 102"    // Muted medium gray for subtitles, captions, ticks (#666666)
local wc_grid           "234 234 234"    // Thin light gray horizontal gridlines (#EAEAEA)
local wc_axis           "204 204 204"    // Subtle axis baseline & tick marks (#CCCCCC)

* ------------------------------------------------------------------------------
* 3. Categorical Series Order (Plots 1 through 8)
* ------------------------------------------------------------------------------
local color1            "`customcolor1'"
local color2            "`customcolor2'"
local color3            "`customcolor3'"
local color4            "`customcolor4'"
local color5            "`customcolor5'"
local color6            "`customcolor6'"
local color7            "`customcolor7'"
local color8            "`customcolor8'"

* ------------------------------------------------------------------------------
* 4. Configure Font Face
* ------------------------------------------------------------------------------
capture graph set window fontface "Arial"
capture graph set window fontfacesans "Arial"
capture graph set eps fontfacesans "Arial"
capture graph set ps fontfacesans "Arial"
capture graph set svg fontfacesans "Arial"

* ------------------------------------------------------------------------------
* 5. Generate Color Style Files (color-*.style)
*    Allows direct usage of color names in any graph:
*    e.g., mcolor(customcolor1), lcolor(customcolor2), lcolor(wc_axis)
* ------------------------------------------------------------------------------
capture program drop MakeColorStyle
program define MakeColorStyle
    args cname rgb seq filepath
    if "`seq'" == "" local seq 9500
    capture file close _fcol
    file open _fcol using "`filepath'", write replace
    file write _fcol "*! version 1.0.0 Color style: `cname'" _n
    file write _fcol "sequence `seq'" _n
    file write _fcol `"label "`cname'""' _n
    file write _fcol `"set rgb "`rgb'""' _n
    file close _fcol
end

if `make_color_styles' == 1 {
    local custom_colors ///
        customcolor1 customcolor2 customcolor3 customcolor4 ///
        customcolor5 customcolor6 customcolor7 customcolor8

    local structural_colors ///
        wc_axis wc_bg wc_body wc_grid wc_title

    local seq = 9500
    foreach c of local custom_colors {
        local rgb "``c''"
        MakeColorStyle "`c'" "`rgb'" `seq' "`root'/color-`c'.style"
        local ++seq
    }

    foreach c of local structural_colors {
        local rgb "``c''"
        MakeColorStyle "`c'" "`rgb'" `seq' "`root'/color-`c'.style"
        local ++seq
    }
}

* ------------------------------------------------------------------------------
* 6. Initialize grstyle and Generate scheme-`scheme_name'.scheme
* ------------------------------------------------------------------------------
set scheme s2color
grstyle clear
grstyle init `scheme_name', replace

* Base styling: white background, horizontal tick labels, zero default grid
grstyle set plain, nogrid horizontal

* Canvas and Background: Pure white, zero outer box, zero inner frame
grstyle color background "`wc_bg'"
grstyle color plotregion none
grstyle color graphregion "`wc_bg'"
grstyle color plotregion_line none
grstyle color graphregion_line none
grstyle linestyle plotregion none
grstyle linestyle graphregion none
grstyle color filled none
grstyle color textbox none

* Typography Colors: Dark charcoal headings, muted gray secondary text
grstyle color heading "`wc_title'"
grstyle color subheading "`wc_body'"
grstyle color body "`wc_body'"
grstyle color small_body "`wc_body'"
grstyle color caption "`wc_body'"
grstyle color note "`wc_body'"
grstyle color text_option "`wc_body'"
grstyle color axis_title "`wc_title'"
grstyle color tick_label "`wc_body'"
grstyle color tick_biglabel "`wc_body'"
grstyle color minortick_label "`wc_body'"
grstyle color tick_label_prep "`wc_body'"
grstyle color label "`wc_body'"
grstyle color small_label "`wc_body'"
grstyle color key_label "`wc_body'"
grstyle color legend_title "`wc_title'"
grstyle color bylabel "`wc_title'"

* Typography Sizes (Refined hierarchy matching R ggplot2):
grstyle gsize heading medium
grstyle gsize subheading small
grstyle gsize axis_title small
grstyle gsize tick_label small
grstyle gsize tick_biglabel small
grstyle gsize body 2.4
grstyle gsize small_body 2.4
grstyle gsize caption 2.4
grstyle gsize note 2.4
grstyle gsize text_option small
grstyle gsize key_label small
grstyle gsize legend_title small
grstyle gsize bylabel medium

* Spacing & Padding:
grstyle gsize axis_title_gap tiny
grstyle margin axis_title zero

* Plot region margins calibrated for ~3.5% padding (matching ggplot2 defaults)
grstyle margin plotregion medium
grstyle margin twoway medium

* Title and Subtitle: Left-aligned and spanning (top-left)
grstyle yesno title_span yes
grstyle yesno subtitle_span yes
grstyle clockdir title_position 11
grstyle clockdir subtitle_position 11

* Notes and Captions: Left-aligned at bottom (bottom-left)
grstyle yesno caption_span yes
grstyle yesno note_span yes
grstyle clockdir note_position 7
grstyle clockdir caption_position 7

* Axes & Gridlines:
* Eliminate vertical (Y) axis line and Y-axis tick marks
grstyle axisstyle vertical_default vertical_nolinetick
grstyle axisstyle vertical_withgrid vertical_nolinetick
grstyle axisstyle vertical_nogrid vertical_nolinetick
grstyle axisstyle bar_scale_vert vertical_nolinetick
grstyle axisstyle box_scale_vert vertical_nolinetick
grstyle axisstyle dot_scale_vert vertical_nolinetick
grstyle axisstyle bar_group horizontal_nolinetick
grstyle axisstyle bar_var horizontal_nolinetick
grstyle axisstyle bar_super horizontal_nolinetick
grstyle ticksetstyle major_vert_withgrid major_vert_notick
grstyle ticksetstyle major_vert_default major_vert_notick
grstyle ticksetstyle major_vert_nogrid major_vert_notick

* Turn ON horizontal gridlines (drawn along vertical axis)
grstyle anglestyle vertical_tick horizontal
grstyle yesno draw_major_vgrid yes
grstyle yesno draw_major_nlt_vgrid yes
grstyle yesno draw_major_nt_vgrid yes
grstyle yesno draw_major_nl_vgrid yes
grstyle yesno draw_minor_vgrid no
grstyle color major_grid "`wc_grid'"
grstyle color minor_grid "`wc_grid'"
grstyle linewidth major_grid thin

* Turn OFF all vertical gridlines (grid along horizontal axis)
grstyle yesno draw_major_hgrid no
grstyle yesno draw_minor_hgrid no
grstyle color major_hgrid none
grstyle linestyle major_hgrid none
grstyle linepattern major_hgrid blank
grstyle color hgrid none
grstyle linestyle hgrid none
grstyle linepattern hgrid blank

* Horizontal (X) axis baseline and ticks: subtle gray (#CCCCCC)
grstyle color axisline "`wc_axis'"
grstyle linewidth axisline thin
grstyle color tick "`wc_axis'"
grstyle linewidth tick thin
grstyle linestyle axis_withgrid axisline
grstyle color axis_withgrid "`wc_axis'"

* Legends: borderless, horizontal layout positioned at top-left
grstyle clockdir legend_position 11
grstyle clockdir by_legend_position 11
grstyle yesno legend_span yes
grstyle areastyle legend none
grstyle color legend_fill none
grstyle color legend_line none
grstyle linestyle legend none
grstyle numstyle legend_rows 1
grstyle gsize legend_key_xsize medsmall
grstyle gsize legend_key_ysize medsmall
grstyle gsize legend_key_gap half_tiny
grstyle gsize legend_colgap tiny
grstyle gsize legend_col_gap tiny
grstyle margin legend zero
grstyle margin legend_boxmargin zero

* Default Solid Filled Circle Markers
grstyle symbol p circle
grstyle symbolsize p small
grstyle symbolsize symbol small
grstyle gsize symbol small

* Default Line Width (medium-thick line matching R ggplot2 linewidth ~0.85)
grstyle linewidth line medthick
grstyle linewidth lineplot medthick

* Bar and Box Proportions (Calibrated to match R geom_col and geom_boxplot)
grstyle relsize bar_gap 100pct
grstyle relsize bar_groupgap 100pct
grstyle relsize bar_outergap 20pct
grstyle relsize box_gap 75pct
grstyle relsize box_groupgap 100pct
grstyle relsize box_outergap 20pct

* Confidence Intervals (Custom Color 1 20% soft tint ribbon without outline)
grstyle color ci_area "`customcolor1'%20"
grstyle color ci_arealine "`customcolor1'%0"
grstyle linestyle ci_arealine none
grstyle color ci2_area "`customcolor2'%20"
grstyle color ci2_arealine "`customcolor2'%0"
grstyle linestyle ci2_arealine none

* Multi-panel Facets (by-plots): clean transparent header, zero banner shading
grstyle bygraphstyle bygraph default
grstyle bygraphstyle default default
grstyle color bylabel_outline none
grstyle linestyle bylabel_outline none
grstyle color bylabel_box none
grstyle color bylabel_fill "`wc_bg'"
grstyle color bylabel "`wc_title'"
grstyle areastyle by_title none
grstyle yesno by_legend_force_draw no
grstyle yesno by_outer_box no

* Cleveland Dot Plots: subtle gray leader dots, no vertical baseline
grstyle color dots "`wc_axis'"
grstyle color dotmarkline "`wc_axis'"
grstyle axisstyle dot_group horizontal_nolinetick
grstyle axisstyle dot_var horizontal_nolinetick
grstyle axisstyle dot_super horizontal_nolinetick

* Assign Categorical Colors to Plot Series (1 through 8)
forvalues i = 1/8 {
    local c "`color`i''"
    grstyle color p`i' "`c'"
    grstyle color p`i'markfill "`c'"
    grstyle color p`i'markline "`c'"
    grstyle color p`i'line "`c'"
    grstyle color p`i'lineplot "`c'"
    grstyle color p`i'bar "`c'"
    grstyle color p`i'barline "`c'"
    grstyle color p`i'box "`c'"
    grstyle color p`i'boxline "`c'"
    grstyle color p`i'pie "`c'"
    grstyle color p`i'area "`c'"
    grstyle color p`i'arealine "`c'"
    grstyle color p`i'dot "`c'"
    grstyle color p`i'dotmark "`c'"
    grstyle symbol p`i' circle
    grstyle symbolsize p`i' small
    grstyle linewidth p`i'line medthick
    grstyle linewidth p`i'lineplot medthick
    grstyle linewidth p`i'area medthick
}

* Print confirmation
di as res "Successfully configured `scheme_title' Stata scheme (scheme-`scheme_name'.scheme)."
if `make_color_styles' == 1 {
    di as res "Successfully generated `scheme_title' color styles (color-*.style) in `root'."
}
