DOC=task_bench

# dependencies via include files
INCLUDED_TEX = 0_abstract.tex \
	1_introduction.tex \
	2_metg.tex \
	3_task_bench.tex \
	4_implementation.tex \
	f1_flops_mpi.tex \
	f2_efficiency_mpi.tex \
	f3_weak_scaling_mpi.tex \
	f4_strong_scaling_mpi.tex
INCLUDED_FIGS = figs/task-bench-results/compute/flops_stencil_mpi.pdf \
	figs/task-bench-results/compute/efficiency_stencil_mpi.pdf \
	figs/task-bench-results/compute/weak_mpi.pdf \
	figs/task-bench-results/compute/strong_mpi.pdf

.PHONY: all
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

.PHONY: figures
figures:
	(if [ ! -d figs/task-bench ]; then \
		git clone https://github.com/StanfordLegion/task-bench.git figs/task-bench; \
	else \
		git -C figs/task-bench pull --ff-only; \
	fi)
	(if [ ! -d figs/task-bench-results ]; then \
		git clone https://github.com/StanfordLegion/task-bench-results.git figs/task-bench-results; \
	else \
		git -C figs/task-bench-results pull --ff-only; \
	fi)
	(cd figs/task-bench-results/compute && ../../task-bench/scripts/render_all.sh crop)
	(cd figs/task-bench-results/communication && ../../task-bench/scripts/render_all.sh crop)
	(cd figs/task-bench-results/imbalance && ../../task-bench/scripts/render_all.sh crop)

.PHONY: spelling
spelling:
	for f in *.tex; do aspell -p ./aspell.en.pws --repl=./aspell.en.prepl -c $$f; done

.PHONY: clean
clean:
	rm -f *.bbl *.aux *.log *.out *.blg *.lot *.lof *.dvi $(DOC).pdf $(DOC)-ext.pdf

.PHONY: zip
zip:
	zip -r task_bench.zip *.tex *.cls Makefile *.sty *.bib
