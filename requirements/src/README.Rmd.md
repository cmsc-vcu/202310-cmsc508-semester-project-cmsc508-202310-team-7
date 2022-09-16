---
---
# Preprocessing markdown files

This folder contains examples for pre-processing markdown files. Programming language code (e.g., python, r, mermaid, etc.) and results (e.g., program output, graphics, etc.) can be embedded and EXECUTED within markdown files by using a preprocessor. The resulting Markdown .md file will be "GITHUB" ready, and will look pretty when viewed on GITHUB.

In this folder, I'm using the "R" programming language. The original code is stored in an "R-markdown" file, that is, a file with the ".Rmd" extension. As I improve and iterate my code, I convert the ".Rmd" files into regular ".md" by feeding them to R. The entire process is orchestrated through the Makefile.

The Makefile contains instructions for creating GITHUB ready markdown .md files AND instructions for creating PDF versions of the files. Look at the .Rmd files, then review the similiarly named .md, .html, and .pdf files.

The workflow is simple:

1. Edit the .Rmd file.
1. "make" the .md file. Pandoc will process the .Rmd file and create a .md file, an .html file, and a .pdf file.
1. Review the results by viewing the .html or .pdf, repeating steps 1-3 until you're happy, done, or both.
1. Add and commit any changes to the repo.
1. Push the changes back to your repo.

## Getting started

To get started, you need to install:

1. "R" programming language
1. "make" utility
1. Pandoc document processing utility
