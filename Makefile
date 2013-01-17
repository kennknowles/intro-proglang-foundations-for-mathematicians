PAPER=proglang-for-maths
XELATEX=/usr/texbin/xelatex

all: $(PAPER).html $(PAPER).pdf

#
# Markdown -> HTML + SASS -> CSS
#

$(PAPER).html: $(PAPER).md stylesheets/research-paper.css Makefile
	pandoc \
		--to=html5 \
		--standalone \
		--section-divs \
		--smart \
		--mathjax \
		--css=stylesheets/research-paper.css \
		--output="$(PAPER).html" \
		$(PAPER).md

stylesheets/research-paper.css: sass/research-paper.scss
	compass compile

#
# Markdown -> Latex -> PDF
#

$(PAPER).tex: $(PAPER).md Makefile
	pandoc \
		--to=latex \
		--standalone \
		--smart \
		--output="$(PAPER).tex" \
		$(PAPER).md

$(PAPER).pdf: $(PAPER).tex 
	$(XELATEX) $(PAPER).tex

