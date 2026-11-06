{smcl}
{* *! version 1.0.0  06nov2026}{...}
{viewerjumpto "Syntax" "wildcat##syntax"}{...}
{viewerjumpto "Description" "wildcat##description"}{...}
{viewerjumpto "Colors" "wildcat##colors"}{...}
{viewerjumpto "Relationship to R ggplot2" "wildcat##ggplot2"}{...}
{viewerjumpto "Examples" "wildcat##examples"}{...}
{viewerjumpto "Appendix: R ggplot2 Code Equivalents" "wildcat##appendix_r"}{...}
{viewerjumpto "Customizing the Scheme" "wildcat##custom"}{...}
{viewerjumpto "Palette Commands" "wildcat##palette"}{...}
{viewerjumpto "Repository & Updates" "wildcat##repository"}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:wildcat} {hline 2}}Modern Stata graph scheme synchronized with R ggplot2 and Northwestern University brand colors{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
Set as current session scheme:

{p 12 16 2}
{cmd:set scheme wildcat} [{cmd:,} {cmd:permanently}]

{p 8 16 2}
Apply to an individual graph:

{p 12 16 2}
{it:graph_command} {cmd:...} [{cmd:,} {it:...} {cmd:scheme(wildcat)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:wildcat} is a modern, publication-grade Stata graph scheme designed to align closely with the clean, minimalist aesthetic of R's {cmd:ggplot2} ({cmd:theme_minimal()} and companion {cmd:theme_wildcat()}). It is part of the {browse "https://github.com/aarondwolf/wildcat":Wildcat repository}, which also includes a companion Northwestern University Beamer presentation theme and matching R and Python graph themes.

{pstd}
Key design features include:

{phang2}o {bf:Northwestern Brand Palette}: Official Northwestern University colors for series markers, lines, bars, and fills.{p_end}
{phang2}o {bf:Calibrated Typography}: High-contrast dark charcoal headings ({cmd:wc_title}) and muted gray secondary text ({cmd:wc_body}) for axis titles, subtitles, captions, and tick labels.{p_end}
{phang2}o {bf:Minimalist Grid}: Subtle horizontal gridlines along the vertical axis ({cmd:wc_grid}); vertical gridlines and tick marks eliminated for an uncluttered reading experience.{p_end}
{phang2}o {bf:Flush Left Alignment}: Titles, subtitles, captions, and notes aligned to the left margin, matching ggplot2.{p_end}
{phang2}o {bf:Unshaded Facet Strips}: By-graph subheadings rendered cleanly on white backgrounds without gray boxes or framing borders.{p_end}


{marker colors}{...}
{title:Available Colors}

{pstd}
Installing the {cmd:wildcat} package installs two sets of named Stata color styles available across all Stata graph commands:

{pstd}
{bf:1. Northwestern University Brand Colors}

{p2colset 8 28 30 2}{...}
{p2col:{cmd:nupurple}}Northwestern Purple (#4E2A84){p_end}
{p2col:{cmd:nudarkorange}}Dark Orange (#CA7C1B){p_end}
{p2col:{cmd:nubrightblue}}Bright Blue (#5091CD){p_end}
{p2col:{cmd:nudarkgreen}}Dark Green (#008656){p_end}
{p2col:{cmd:nubrightorange}}Bright Orange (#FFC520){p_end}
{p2col:{cmd:nubrightteal}}Bright Teal (#7FCECD){p_end}
{p2col:{cmd:nubrightred}}Bright Red (#EF553F){p_end}
{p2col:{cmd:nudarkblue}}Dark Blue (#0D2D6C){p_end}
{p2col:{cmd:nudarkteal}}Dark Teal (#007FA4){p_end}
{p2col:{cmd:nubrightgreen}}Bright Green (#58B9AB){p_end}
{p2col:{cmd:nudarkyellow}}Dark Yellow (#D9C826){p_end}
{p2col:{cmd:nupurple50}}Purple 50% tint (#9380C0){p_end}
{p2col:{cmd:nupurple150}}Purple 150% shade (#260841){p_end}
{p2col:{cmd:nupurple40}}Purple 40% tint (#A495C3){p_end}
{p2col:{cmd:nupurple20}}Purple 20% tint (#CCC4DF){p_end}
{p2col:{cmd:nubrightyellow}}Bright Yellow (#EDE93B){p_end}
{p2col:{cmd:nudarkred}}Dark Red (#D85820){p_end}
{p2col:{cmd:nurichblack}}Rich Black (#000000){p_end}
{p2colreset}{...}

{pstd}
{bf:2. Wildcat Theme Structural & Semantic Colors}

{p2colset 8 28 30 2}{...}
{p2col:{cmd:wc_bg}}Pure white canvas / plot background (#FFFFFF){p_end}
{p2col:{cmd:wc_grid}}Subtle horizontal gridline gray (#EBEBEB){p_end}
{p2col:{cmd:wc_axis}}Axis baseline and tick mark gray (#CCCCCC){p_end}
{p2col:{cmd:wc_title}}High-contrast dark charcoal title & heading (#222222){p_end}
{p2col:{cmd:wc_body}}Muted gray body text, subtitles, captions, & labels (#666666){p_end}
{p2colreset}{...}


{marker ggplot2}{...}
{title:Relationship to R ggplot2 & Built-in Stata Colors}

{pstd}
The structural colors ({cmd:wc_*}) are directly calibrated to match R's {cmd:ggplot2} defaults under {cmd:theme_minimal()}:

{phang2}o {cmd:wc_bg} (#FFFFFF) matches R's {cmd:element_rect(fill = "white")}. It is identical to built-in Stata {cmd:white} or {cmd:gs16}.{p_end}
{phang2}o {cmd:wc_grid} (#EBEBEB) matches R's panel gridlines {cmd:element_line(color = "#EBEBEB")}. It is practically indistinguishable from built-in Stata {cmd:gs15} / {cmd:dimgray} (#E6E6E6).{p_end}
{phang2}o {cmd:wc_axis} (#CCCCCC) matches R's axis baselines. It is very close to built-in Stata {cmd:gs13} (#CFCFCF).{p_end}
{phang2}o {cmd:wc_title} (#222222) matches R's dark titles. It is practically identical to built-in Stata {cmd:gs2} (#202020).{p_end}
{phang2}o {cmd:wc_body} (#666666) matches R's axis text and caption color. It corresponds closely to built-in Stata {cmd:gs6} (#606060) or {cmd:gray}.{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Click any underlined command below to run the example in Stata:

{pstd}
1. {bf:Initialize Scheme & Load Data}

{phang2}{stata "sysuse auto, clear":. sysuse auto, clear}{p_end}
{phang2}{stata "set scheme wildcat":. set scheme wildcat}{p_end}

{pstd}
2. {bf:Scatter Plot with Linear Fit & Confidence Interval}

{phang2}{stata `"twoway (lfitci mpg weight) (scatter mpg weight), title("{bf:Vehicle Fuel Economy}") subtitle("Miles per gallon vs. vehicle weight") xtitle("Weight (lbs)") ytitle("Mileage (mpg)") note("Source: 1978 Automobile Data")"':. twoway (lfitci mpg weight) (scatter mpg weight), title("{bf:Vehicle Fuel Economy}") ...}{p_end}

{pstd}
3. {bf:Multi-group Bar Chart}

{phang2}{stata `"graph bar (mean) mpg, over(rep78) over(foreign) asyvars title("{bf:Average Mileage by Repair Record and Origin}") subtitle("Mean MPG across vehicle classes") ytitle("Mean Mileage (mpg)") legend(rows(1))"':. graph bar (mean) mpg, over(rep78) over(foreign) asyvars ...}{p_end}

{pstd}
4. {bf:Faceted (by-group) Scatter Plot}

{phang2}{stata `"scatter mpg weight, by(foreign, title("{bf:Mileage vs. Weight by Origin}") subtitle("Domestic vs. Foreign Fleets") note("Source: 1978 Automobile Data"))"':. scatter mpg weight, by(foreign, title("{bf:Mileage vs. Weight by Origin}") ...)}{p_end}

{pstd}
5. {bf:Kernel Density Plot with Shaded Area}

{phang2}{stata `"twoway (kdensity mpg if foreign==0, area color(nupurple%50)) (kdensity mpg if foreign==1, area color(nudarkorange%50)), title("{bf:Fuel Efficiency Distribution}") subtitle("Kernel density estimates by origin") xtitle("Mileage (mpg)") ytitle("Density") legend(order(1 "Domestic" 2 "Foreign") rows(1))"':. twoway (kdensity mpg if foreign==0, area color(nupurple%50)) ...}{p_end}

{pstd}
6. {bf:Horizontal Dot Plot}

{phang2}{stata `"graph dot (mean) mpg, over(make in 1/10) title("{bf:Selected Model Mileage}") ytitle("Miles per Gallon")"':. graph dot (mean) mpg, over(make in 1/10) ...}{p_end}


{marker appendix_r}{...}
{title:Appendix: R ggplot2 Code Equivalents}

{pstd}
The {cmd:wildcat} scheme has an official fraternal twin for R users: {cmd:theme_wildcat()}, provided in {cmd:r/theme_wildcat.R}.

{pstd}
{it:Note on visual alignment}: The R and Stata implementations share identical Northwestern brand color palettes, categorical sequences, typography scales, and gridline parameters. Because Stata's graph engine and R's grid/ggplot2 layout systems calculate margins, font metrics, and bounding boxes using different algorithms, the outputs are designed to be fraternal twins — extremely close in visual spirit, but not pixel-perfect.

{pstd}
Below are the equivalent R scripts for the examples above:

{pstd}
{bf:Setup in R}:{p_end}

        {cmd:library(ggplot2)}
        {cmd:source("r/theme_wildcat.R")}

{pstd}
{bf:R Example 1: Scatter Plot with Linear Fit & Confidence Ribbon}:{p_end}

        {cmd:ggplot(mtcars, aes(x = wt * 1000, y = mpg)) +}
        {cmd:  geom_smooth(method = "lm", color = "#4E2A84", fill = "#CCC4DF") +}
        {cmd:  geom_point(color = "#4E2A84") +}
        {cmd:  labs(title = "Vehicle Fuel Economy",}
        {cmd:       subtitle = "Miles per gallon vs. vehicle weight",}
        {cmd:       x = "Weight (lbs)", y = "Mileage (mpg)",}
        {cmd:       caption = "Source: 1978 Automobile Data") +}
        {cmd:  theme_wildcat()}

{pstd}
{bf:R Example 2: Grouped Bar Chart}:{p_end}

        {cmd:ggplot(mtcars, aes(x = factor(gear), fill = factor(am, labels = c("Domestic", "Foreign")))) +}
        {cmd:  geom_bar(position = position_dodge(0.8), width = 0.58) +}
        {cmd:  scale_fill_wildcat() +}
        {cmd:  labs(title = "Fleet Distribution by Transmission",}
        {cmd:       subtitle = "Counts across forward gears",}
        {cmd:       x = "Gears", y = "Count", fill = "Origin") +}
        {cmd:  theme_wildcat()}

{pstd}
{bf:R Example 3: Faceted Multi-panel Plot}:{p_end}

        {cmd:ggplot(mtcars, aes(x = wt * 1000, y = mpg)) +}
        {cmd:  geom_point(color = "#4E2A84") +}
        {cmd:  facet_wrap(~ factor(am, labels = c("Domestic", "Foreign"))) +}
        {cmd:  labs(title = "Mileage vs. Weight by Origin",}
        {cmd:       subtitle = "Domestic vs. Foreign Fleets",}
        {cmd:       x = "Weight (lbs)", y = "Mileage (mpg)",}
        {cmd:       caption = "Source: 1978 Automobile Data") +}
        {cmd:  theme_wildcat()}

{pstd}
{bf:R Example 4: Kernel Density with Shaded Area}:{p_end}

        {cmd:ggplot(mtcars, aes(x = mpg, fill = factor(am, labels = c("Domestic", "Foreign")))) +}
        {cmd:  geom_density(alpha = 0.5, color = NA) +}
        {cmd:  scale_fill_wildcat() +}
        {cmd:  labs(title = "Fuel Efficiency Distribution",}
        {cmd:       subtitle = "Kernel density estimates by origin",}
        {cmd:       x = "Mileage (mpg)", y = "Density", fill = "Origin") +}
        {cmd:  theme_wildcat()}


{marker custom}{...}
{title:Customizing the Scheme / Creating Your Own Version}

{pstd}
You can easily create your own customized Stata scheme (e.g. for another university, organization, or personal aesthetic) using the generator script {cmd:stata/make_scheme.do}.

{pstd}
The top of {cmd:stata/make_scheme.do} includes a dedicated user customization block:

        {cmd:local scheme_name       "wildcat"}        {it:// Compiles scheme-`scheme_name'.scheme}
        {cmd:local scheme_title      "Wildcat"}        {it:// Display title}
        {cmd:local make_color_styles 1}                {it:// 1 = write color-*.style files, 0 = skip}

        {it:* Un-comment to add your own custom colors:}
        {cmd:local myblue   "0 51 102"}
        {cmd:local mygold   "255 199 44"}
        {cmd:local custom_colors myblue mygold}

{pstd}
{bf:Suggestions for customizing}:

{phang2}1. {bf:Change the Scheme Name}: Set {cmd:local scheme_name "mytheme"} to compile {cmd:scheme-mytheme.scheme}. You can then set it permanently via {cmd:set scheme mytheme, permanently}.{p_end}

{phang2}2. {bf:Add Custom Brand Colors}: Un-comment the custom colors block and define your RGB values. When {cmd:make_color_styles} is 1, {cmd:make_scheme.do} generates standalone {cmd:color-*.style} files automatically (e.g. {cmd:color-myblue.style}), enabling you to use {cmd:mcolor(myblue)} or {cmd:lcolor(mygold)} in any graph command.{p_end}

{phang2}3. {bf:Reorder Discrete Plot Series}: Reassign {cmd:color1} through {cmd:color12} in Section 3 to specify the sequence of colors for multi-series plots.{p_end}

{phang2}4. {bf:Adjust Structural Canvas Elements}: In Section 2, modify {cmd:wc_bg} (canvas background), {cmd:wc_grid} (gridlines), {cmd:wc_axis} (axis lines), {cmd:wc_title} (heading charcoal), and {cmd:wc_body} (muted gray text).{p_end}

{phang2}5. {bf:Compile}: View or run the generator script directly from Stata:
{break}{stata "view stata/make_scheme.do":. view stata/make_scheme.do}
{break}{stata "do stata/make_scheme.do":. do stata/make_scheme.do}
{p_end}

{pstd}
{bf:Packaging Your Custom Scheme in One Folder}:

{pstd}
To share or archive your scheme as a self-contained Stata package, place the following files into a single folder (e.g., {cmd:mytheme_pkg/}):

        {cmd:stata.toc}                  {it:// Package table of contents}
        {cmd:mytheme.pkg}                {it:// Package manifest}
        {cmd:scheme-mytheme.scheme}      {it:// Compiled scheme file}
        {cmd:color-*.style}              {it:// Generated custom color styles}
        {cmd:mytheme.sthlp}              {it:// (Optional) Help file}

{pstd}
A minimal {cmd:stata.toc} contains:

        {cmd:v 3}
        {cmd:d 'MYTHEME': Custom Stata graph scheme}
        {cmd:p mytheme}

{pstd}
A minimal {cmd:mytheme.pkg} contains:

        {cmd:v 3}
        {cmd:d 'MYTHEME': Custom Stata graph scheme}
        {cmd:f scheme-mytheme.scheme}
        {cmd:f color-myblue.style}
        {cmd:f color-mygold.style}

{pstd}
{bf:Installing from a Local Folder in Stata}:

{pstd}
Stata's {cmd:net} package manager can install packages directly from a local directory path:

        {cmd:. net from "C:/path/to/mytheme_pkg"}
        {cmd:. net describe mytheme}
        {cmd:. net install mytheme, replace}
        {cmd:. set scheme mytheme, permanently}

{pstd}
{it:Why use net install from local?}
Stata automatically routes scheme files into {cmd:ado/plus/s/}, color styles into {cmd:ado/plus/c/}, and help files into {cmd:ado/plus/m/}. This makes your scheme and custom colors universally accessible across all Stata sessions and projects on your machine, tracked under Stata's official package manager ({cmd:ado dir}).

{pstd}
{it:Quick manual alternative}: You can also simply copy {cmd:scheme-mytheme.scheme} and any {cmd:color-*.style} files directly into your Stata {cmd:PERSONAL} directory (click {stata sysdir:. sysdir} to see its exact path on your system).


{marker palette}{...}
{title:Palette Inspection}

{pstd}
If you have Ben Jann's {cmd:palettes} package installed, you can visualize the palette using:

{phang2}{stata "colorpalette wildcat":. colorpalette wildcat}{p_end}
{phang2}{stata "colorpalette wildcat, title(Northwestern University Brand Colors)":. colorpalette wildcat, title(Northwestern University Brand Colors)}{p_end}


{marker repository}{...}
{title:Repository & Updates}

{pstd}
The latest version of the scheme, full documentation, issue tracker, and companion Beamer presentation and R/Python themes are hosted on GitHub:{break}
{browse "https://github.com/aarondwolf/wildcat":https://github.com/aarondwolf/wildcat}


{marker author}{...}
{title:Author}

{pstd}
Aaron Wolf{break}
Northwestern University{break}
Email: {browse "mailto:aaron.wolf@u.northwestern.edu":aaron.wolf@u.northwestern.edu}{break}
GitHub: {browse "https://github.com/aarondwolf/wildcat":https://github.com/aarondwolf/wildcat}
{p_end}
