* ==============================================================================
* make_scheme.do
* Wildcat Stata Scheme Generator
* Modern Stata graph scheme synchronized with R ggplot2 theme_wildcat
* Incorporates official Northwestern University brand color styles
*
* CUSTOMIZATION GUIDE:
* Want to create your own customized scheme (e.g. for another university, company,
* or personal aesthetic)?
* See the "USER CONFIGURATION & CUSTOMIZATION SECTION" below:
*   1. Change `scheme_name` to your desired name (e.g., "mytheme", "hawkeye").
*   2. Update color RGB definitions with your brand/preferred colors.
*   3. Reorder the categorical plot sequence (`color1` through `color12`).
*   4. Run `do stata/make_scheme.do` to instantly compile your custom scheme!
* ==============================================================================

version 16.0
set more off

* ------------------------------------------------------------------------------
* USER CONFIGURATION & CUSTOMIZATION SECTION
* ------------------------------------------------------------------------------
* Quick custom changes: change the scheme name, brand palette, and series order here.

local scheme_name       "wildcat"        // Scheme identifier: compiles scheme-`scheme_name'.scheme
local scheme_title      "Wildcat"        // Descriptive title for display and comments
local make_color_styles 1                // 1 = write color-*.style files to root, 0 = skip

* Un-comment this block and swap out names to define your own custom colors for distribution with the scheme.
/* 
local custom_color_1 "0 0 0"            // SWap out your custom name and RBG values here (e.g., "mycolor1" "255 0 0" for bright red)
local custom_colors custom_color_1      // This will trigger a color scheme file generation in section 5, below.
*/

* Determine project root directory so files are written to root for net install
local root "."
capture confirm file "stata/make_scheme.do"
if _rc != 0 {
    capture confirm file "../stata/make_scheme.do"
    if _rc == 0 local root ".."
}

* ------------------------------------------------------------------------------
* 1. Check and Install Dependencies
* ------------------------------------------------------------------------------
foreach pkg in grstyle palettes colrspace {
    capture which `pkg'
    if _rc != 0 {
        di as txt "Installing required package: `pkg' from SSC..."
        capture ssc install `pkg', replace
    }
}

* ------------------------------------------------------------------------------
* 2. Northwestern Brand Color Registry & Wildcat Theme Elements
* ------------------------------------------------------------------------------
* Official Northwestern University Brand Colors (Palettes & Accents)
* Reference: https://www.northwestern.edu/brand/
* (To customize: replace or add your own RGB values below)
local nupurple        "78 42 132"      // #4E2A84 - Primary Northwestern Purple
local nupurple150     "38 8 65"        // #260841 - Dark purple
local nupurple50      "147 128 192"    // #9380C0 - Light purple
local nupurple40      "164 149 195"    // #A495C3
local nupurple20      "204 196 223"    // #CCC4DF - Soft tint
local nubrightgreen   "88 185 171"     // #58B9AB
local nubrightteal    "127 206 205"    // #7FCECD
local nubrightblue    "80 145 205"     // #5091CD
local nubrightyellow  "237 233 59"     // #EDE93B
local nubrightorange  "255 197 32"     // #FFC520
local nubrightred     "239 85 63"      // #EF553F
local nudarkgreen     "0 134 86"       // #008656
local nudarkteal      "0 127 164"      // #007FA4
local nudarkblue      "13 45 108"      // #0D2D6C
local nudarkyellow    "217 200 38"     // #D9C826
local nudarkorange    "202 124 27"     // #CA7C1B
local nudarkred       "216 88 32"      // #D85820
local nurichblack     "0 0 0"          // #000000

* Wildcat Structural & Semantic Theme Colors (Non-NU structural elements)
* Note on Stata built-in color proximity:
*   wc_bg    (255 255 255) is identical to Stata's white / gs16
*   wc_axis  (204 204 204) matches ggplot2 #CCCCCC (very close to Stata's gs13: 208 208 208)
*   wc_grid  (234 234 234) matches ggplot2 #EAEAEA (close to Stata's dimgray: 232 232 232 / gs15: 240 240 240)
*   wc_title (34 34 34)   matches ggplot2 #222222 (close to Stata's gs2: 32 32 32)
*   wc_body  (102 102 102) matches ggplot2 #666666 (close to Stata's gs6: 96 96 96)
local wc_bg           "255 255 255"    // Pure white canvas (#FFFFFF)
local wc_title        "34 34 34"       // Dark charcoal for titles (#222222)
local wc_body         "102 102 102"    // Muted medium gray for subtitles, captions, ticks (#666666)
local wc_grid         "234 234 234"    // Thin light gray horizontal gridlines (#EAEAEA)
local wc_axis         "204 204 204"    // Subtle axis baseline & tick marks (#CCCCCC)

* ------------------------------------------------------------------------------
* 3. Categorical Plot Sequence (Theme Series Order)
* ------------------------------------------------------------------------------
* Set series colors 1 through 12. To customize, swap any color macro below:
local color1          "`nupurple'"         // Plot 1: NU Purple
local color2          "`nudarkorange'"     // Plot 2: Dark Orange
local color3          "`nubrightblue'"     // Plot 3: Bright Blue
local color4          "`nudarkgreen'"      // Plot 4: Dark Green
local color5          "`nubrightorange'"   // Plot 5: Bright Orange
local color6          "`nubrightteal'"     // Plot 6: Bright Teal
local color7          "`nubrightred'"      // Plot 7: Bright Red
local color8          "`nudarkblue'"       // Plot 8: Dark Blue
local color9          "`nudarkteal'"       // Plot 9: Dark Teal
local color10         "`nubrightgreen'"    // Plot 10: Bright Green
local color11         "`nudarkyellow'"     // Plot 11: Dark Yellow
local color12         "`nupurple50'"       // Plot 12: Purple 50%

* ------------------------------------------------------------------------------
* 4. Configure Font Face (Arial matches R ggplot2 sans default on Windows/Mac)
* ------------------------------------------------------------------------------
capture graph set window fontface "Arial"
capture graph set window fontfacesans "Arial"
capture graph set eps fontfacesans "Arial"
capture graph set ps fontfacesans "Arial"
capture graph set svg fontfacesans "Arial"

* ------------------------------------------------------------------------------
* 5. Generate Color Style Files (color-*.style)
*    - Official Northwestern University brand colors (nupurple, nudarkorange, etc.)
*    - Wildcat theme structural colors (wc_axis, wc_bg, wc_grid, wc_title, wc_body)
*    - Custom user-defined colors (if any)
*    Allows direct usage of color names in any graph:
*    e.g., mcolor(nupurple), lcolor(nudarkorange), fcolor(nupurple20%50), lcolor(wc_axis)
* ------------------------------------------------------------------------------
capture program drop MakeWildcatColorStyle
program define MakeWildcatColorStyle
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
    * 18 Official Northwestern Brand Colors (No underscores)
    local nu_colors ///
        nupurple nupurple150 nupurple50 nupurple40 nupurple20 ///
        nubrightgreen nubrightteal nubrightblue nubrightyellow nubrightorange nubrightred ///
        nudarkgreen nudarkteal nudarkblue nudarkyellow nudarkorange nudarkred nurichblack

    * 5 Wildcat Semantic / Structural Colors
    local wc_colors ///
        wc_axis wc_bg wc_body wc_grid wc_title

    local seq = 9500
    foreach c of local nu_colors {
        local rgb "``c''"
        MakeWildcatColorStyle "`c'" "`rgb'" `seq' "`root'/color-`c'.style"
        local ++seq
    }

    foreach c of local wc_colors {
        local rgb "``c''"
        MakeWildcatColorStyle "`c'" "`rgb'" `seq' "`root'/color-`c'.style"
        local ++seq
    }

    * Note: If you want to add your own custom colors, define them above in the USER CONFIGURATION section
    foreach c of local custom_colors {
        local rgb "``c''"
        MakeWildcatColorStyle "`c'" "`rgb'" `seq' "`root'/color-`c'.style"
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

* Typography Colors:
* Dark charcoal for titles, muted gray for subtitles, captions, notes, ticks, and marker labels
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
* Tuned vertical padding between axis title and axis tick numbers
grstyle gsize axis_title_gap tiny
grstyle margin axis_title zero

* Plot region margins:
* Calibrate plotregion and twoway margins to medium (medmargin ~3.5%) to synchronize Y-axis vertical
* height and aspect ratio with R ggplot2 defaults across all graph types
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
* Eliminate vertical (Y) axis line and Y-axis tick marks across ALL graphs (including hbar)
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

* Horizontal (X) axis baseline and ticks: subtle gray (#CCCCCC) across all graphs
grstyle color axisline "`wc_axis'"
grstyle linewidth axisline thin
grstyle color tick "`wc_axis'"
grstyle linewidth tick thin
grstyle linestyle axis_withgrid axisline
grstyle color axis_withgrid "`wc_axis'"

* Legends: borderless, horizontal layout positioned at top-left
* Spanning to the left edge to flush with Y-axis/title margin
* Square legend keys matching R ggplot2 with compact element padding
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

* Default Solid Filled Circle Markers (small size matching R geom_point)
grstyle symbol p circle
grstyle symbolsize p small
grstyle symbolsize symbol small
grstyle gsize symbol small

* Default Line Width (medium-thick line matching R ggplot2 linewidth ~0.85)
grstyle linewidth line medthick
grstyle linewidth lineplot medthick

* Bar and Box Proportions (Calibrated to match R geom_col width 0.58 and geom_boxplot width 0.55):
* In Stata, gaps are specified relative to bar/box thickness. Higher gap percentages
* produce slimmer, refined bars and boxes at the scheme level without per-graph overrides.
grstyle relsize bar_gap 100pct
grstyle relsize bar_groupgap 100pct
grstyle relsize bar_outergap 20pct
grstyle relsize box_gap 75pct
grstyle relsize box_groupgap 100pct
grstyle relsize box_outergap 20pct

* Confidence Intervals (Northwestern Purple 20% soft tint ribbon without outline)
grstyle color ci_area "`nupurple20'"
grstyle color ci_arealine "`nupurple20'%0"
grstyle linestyle ci_arealine none
grstyle color ci2_area "`nubrightblue'%20"
grstyle color ci2_arealine "`nubrightblue'%0"
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

* Assign Categorical Colors to Plot Series (1 through 12)
forvalues i = 1/12 {
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

* Ensure compiled scheme-`scheme_name'.scheme is in root directory
if "`root'" != "." {
    capture copy "scheme-`scheme_name'.scheme" "`root'/scheme-`scheme_name'.scheme", replace
}

* Print confirmation
di as res "Successfully configured `scheme_title' Stata scheme (scheme-`scheme_name'.scheme)."
if `make_color_styles' == 1 {
    di as res "Successfully generated `scheme_title' color styles (color-*.style) for root distribution."
}
