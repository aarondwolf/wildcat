{smcl}
{* *! version 1.0.0  07nov2026}{...}
{viewerjumpto "Syntax" "mytheme##syntax"}{...}
{viewerjumpto "Description" "mytheme##description"}{...}
{viewerjumpto "Colors" "mytheme##colors"}{...}
{viewerjumpto "Examples" "mytheme##examples"}{...}
{viewerjumpto "Customizing" "mytheme##custom"}{...}
{viewerjumpto "Installation" "mytheme##install"}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:scheme-mytheme} {hline 2}}Custom Stata graph scheme template synchronized with R ggplot2{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
Set as current session scheme:

{p 12 16 2}
{cmd:set scheme mytheme} [{cmd:,} {cmd:permanently}]

{p 8 16 2}
Apply to an individual graph:

{p 12 16 2}
{it:graph_command} {cmd:...} [{cmd:,} {it:...} {cmd:scheme(mytheme)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:mytheme} is a customizable, publication-grade Stata graph scheme template designed to align closely with the clean, minimalist aesthetic of R's {cmd:ggplot2} ({cmd:theme_minimal()}).

{pstd}
Key design features include:

{phang2}o {bf:Custom Color Palette}: Distinct series colors for markers, lines, bars, and fills ({cmd:customcolor1} through {cmd:customcolor8}).{p_end}
{phang2}o {bf:Calibrated Typography}: High-contrast dark charcoal headings ({cmd:wc_title}) and muted gray secondary text ({cmd:wc_body}) for axis titles, subtitles, captions, and tick labels.{p_end}
{phang2}o {bf:Minimalist Grid}: Subtle horizontal gridlines along the vertical axis ({cmd:wc_grid}); vertical gridlines and tick marks eliminated for an uncluttered reading experience.{p_end}
{phang2}o {bf:Flush Left Alignment}: Titles, subtitles, captions, and notes aligned to the left margin, matching ggplot2.{p_end}
{phang2}o {bf:Unshaded Facet Strips}: By-graph subheadings rendered cleanly on white backgrounds without gray boxes or framing borders.{p_end}


{marker colors}{...}
{title:Available Colors}

{pstd}
Installing the {cmd:mytheme} package provides named Stata color styles available across all Stata graph commands:

{pstd}
{bf:1. Custom Palette Colors}

{p2colset 8 28 30 2}{...}
{p2col:{cmd:customcolor1}}Steel Blue (#3465A4){p_end}
{p2col:{cmd:customcolor2}}Warm Orange (#F57900){p_end}
{p2col:{cmd:customcolor3}}Fresh Green (#73D216){p_end}
{p2col:{cmd:customcolor4}}Muted Plum (#75507B){p_end}
{p2col:{cmd:customcolor5}}Bronze / Ochre (#C17D11){p_end}
{p2col:{cmd:customcolor6}}Crimson Red (#CC0000){p_end}
{p2col:{cmd:customcolor7}}Dark Teal (#06989A){p_end}
{p2col:{cmd:customcolor8}}Slate Charcoal (#555753){p_end}
{p2colreset}{...}

{pstd}
{bf:2. Structural & Semantic Colors}

{p2colset 8 28 30 2}{...}
{p2col:{cmd:wc_bg}}Pure white canvas / plot background (#FFFFFF){p_end}
{p2col:{cmd:wc_grid}}Subtle horizontal gridline gray (#EAEAEA){p_end}
{p2col:{cmd:wc_axis}}Axis baseline and tick mark gray (#CCCCCC){p_end}
{p2col:{cmd:wc_title}}High-contrast dark charcoal title & heading (#222222){p_end}
{p2col:{cmd:wc_body}}Muted gray body text, subtitles, captions, & labels (#666666){p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

{pstd}
Click any underlined command below to run the example in Stata:

{pstd}
1. {bf:Initialize Scheme & Load Data}

{phang2}{stata "sysuse auto, clear":. sysuse auto, clear}{p_end}
{phang2}{stata "set scheme mytheme":. set scheme mytheme}{p_end}

{pstd}
2. {bf:Scatter Plot with Linear Fit & Confidence Interval}

{phang2}{stata `"twoway (lfitci mpg weight) (scatter mpg weight), title("{bf:Vehicle Fuel Economy}") subtitle("Miles per gallon vs. vehicle weight") xtitle("Weight (lbs)") ytitle("Mileage (mpg)") note("Source: 1978 Automobile Data")"':. twoway (lfitci mpg weight) (scatter mpg weight), title("{bf:Vehicle Fuel Economy}") ...}{p_end}

{pstd}
3. {bf:Multi-group Bar Chart}

{phang2}{stata `"graph bar (mean) mpg, over(rep78) over(foreign) asyvars title("{bf:Average Mileage by Repair Record and Origin}") subtitle("Mean MPG across vehicle classes") ytitle("Mean Mileage (mpg)") legend(rows(1))"':. graph bar (mean) mpg, over(rep78) over(foreign) asyvars ...}{p_end}

{pstd}
4. {bf:Faceted (by-group) Scatter Plot}

{phang2}{stata `"scatter mpg weight, by(foreign, title("{bf:Mileage vs. Weight by Origin}") subtitle("Domestic vs. Foreign Fleets") note("Source: 1978 Automobile Data"))"':. scatter mpg weight, by(foreign, title("{bf:Mileage vs. Weight by Origin}") ...)}{p_end}


{marker custom}{...}
{title:Customizing the Scheme}

{pstd}
To adjust the colors or settings:

{phang2}1. Open {cmd:make_scheme_mytheme.do} in your editor or Stata.{p_end}
{phang2}2. Edit the RGB values under {cmd:customcolor1} through {cmd:customcolor8} or change {cmd:scheme_name}.{p_end}
{phang2}3. Execute {cmd:do make_scheme_mytheme.do} to regenerate {cmd:scheme-mytheme.scheme} and {cmd:color-*.style}.{p_end}


{marker install}{...}
{title:Local Installation}

{pstd}
To install into your Stata environment so it is permanently available:

{phang2}{cmd:. net from "C:/path/to/mytheme"}{p_end}
{phang2}{cmd:. net install mytheme, replace}{p_end}
{phang2}{cmd:. set scheme mytheme, permanently}{p_end}
