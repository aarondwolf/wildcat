# wildcat
A modern, highly customizable beamer theme.

## Overview
This beamer theme uses branding guidelines (colors, fonts, and logos) from [Northwestern University](https://www.northwestern.edu/brand/visual-identity/). The design mimics Northwestern's facets Zoom backgrounds, and the style files build on the amazing Stack Exchange answer by [Claudio Fiandrino](https://tex.stackexchange.com/questions/146529/design-a-custom-beamer-theme-from-scratch). This is not an official, Northwestern-approved beamer template: This is simply my own attempt to make a simple, modern beamer theme. 

## How do I use this?
You will simply need to have all the .sty files in the source folder in your LaTeX file's working directory. Then add `\usetheme{wildcat}` to your preamble. See source/wildcat-example.tex for an example document. 

## Can I customize it?
Yes! The theme is designed to be (hopefully) easy to customize with your own colors, fonts, and even background patterns. The file source/wildcat-demo.pdf provides numerous examples of how to change the these your liking.  

## Fonts
For the font theme to work, you will need to have the Campton and Akkurat Pro fonts installed on your system. If you don't you have two options:
1. Change the beamerfontthemewildcat.sty file to use fonts you have on hand.
2. Use the Overleaf-friendly font theme: Add `\usefonttheme{wildcat-overleaf}` in your preamble.

You will also need to use XeLaTeX to compile. If you use PDFLaTeX, it will fail.

## Stability
I highly doubt this is stable. This is still a work in progress. So, if you come across any errors, please send me a message via GitHub!

## Coming Soon
Here are my plans for what I want to add:
- More color themes (light version, plus other pallettes entirely)
- A few pre-selected background patterns to choose from, not just facet.
