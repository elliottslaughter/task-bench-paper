DOC=task_bench

# dependencies via include files
INCLUDED_TEX = 1_introduction.tex
INCLUDED_FIGS = 

all: $(DOC).pdf 

$(DOC).pdf: $(DOC).tex bibliography.bib $(INCLUDED_TEX) $(INCLUDED_FIGS)

%.pdf: %.tex bibliography.bib
	pdflatex -halt-on-error $*.tex
	(if grep -q bibliography $*.tex; \
	then \
		bibtex $*; \
		pdflatex -halt-on-error $*.tex; \
	fi)
	pdflatex -halt-on-error $*.tex

%.pdf: %.tex
	pdflatex -halt-on-error $*.tex
	pdflatex -halt-on-error $*.tex

%.dvi: %.tex bibliography.bib figs_as_eps
	pdflatex -output-format dvi -halt-on-error $*.tex
	bibtex $*
	pdflatex -output-format dvi -halt-on-error $*.tex
	pdflatex -output-format dvi -halt-on-error $*.tex

%.ps : %.dvi
	dvips $^

spelling :
	for f in *.tex; do aspell -p ./aspell.en.pws --repl=./aspell.en.prepl -c $$f; done

clean:
	rm -f *.bbl *.aux *.log *.out *.blg *.lot *.lof *.dvi $(DOC).pdf $(DOC)-ext.pdf

zip:
	zip -r task_bench.zip *.tex *.cls Makefile *.sty *.bib
