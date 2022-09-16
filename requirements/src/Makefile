.SILENT:

## this is a sample MAKEFILE. To use it, you'll to install
## both MAKE and PANDOC on your computer. 

Phase-1-requirements.html Phase-1-requirements.md : Phase-1-requirements.Rmd ; $(recipe-rmd-to-md)
Phase-2-requirements.html Phase-2-requirements.md : Phase-2-requirements.Rmd ; $(recipe-rmd-to-md)

Phase-1-requirements.pdf : Phase-1-requirements.html ; $(recipe-any-to-pdf)
Phase-2-requirements.pdf : Phase-2-requirements.html ; $(recipe-any-to-pdf)

..\Phase-1-requirements.md : Phase-1-requirements.md ; $(recipe-copy-file)
..\Phase-2-requirements.md : Phase-2-requirements.md ; $(recipe-copy-file)

README.html README.md : README.Rmd ; $(recipe-rmd-to-md)
README.pdf : README.html; $(recipe-any-to-pdf)


all : ..\Phase-1-requirements.md ..\Phase-2-requirements.md Phase-1-requirements.pdf Phase-2-requirements.pdf README.md README.pdf

clean:
	del *.pdf
	del *.html 
	del *.md


define recipe-any-to-pdf
	@echo Building $(@) from: $(^)
	pandoc -s -V geometry:margin=1in \
	-o $(@) \
	$(^)
endef


define recipe-rmd-to-md
	@echo Knitting rmd to md: $(@)
	r.exe --slave --quiet -e "library(knitr); library(markdown); library(rmarkdown); build.file='$(@)'; opts_knit$$set(progress = FALSE, verbose = FALSE); render('$(firstword $(^))')"
endef

define recipe-copy-file
	@echo Copying $(^) $(@)
	copy $(^) $(@)
endef
