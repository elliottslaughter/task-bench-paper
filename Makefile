DOC=task_bench

# dependencies via include files
INCLUDED_TEX = header.tex \
	0_abstract.tex \
	1_introduction.tex \
	2_task_bench.tex \
	3_implementation.tex \
	4_metg.tex \
	5_evaluation.tex \
	6_related.tex \
	7_conclusion.tex \
	f1_flops_mpi.tex \
	f2_efficiency_mpi.tex \
	f3_weak_scaling_mpi.tex \
	f4_strong_scaling_mpi.tex \
	f5_task_graphs.tex \
	l0_compute_kernel.tex \
	l1_code_sample.tex \
	l2_mpi_sample.tex \
	t0_equations.tex \
	t1_systems.tex \
	t2_parameters.tex \
	t3_api.tex \
	e0_flags.tex \
	e1_flops.tex \
	e2_efficiency.tex \
	e3_metg_compute.tex \
	e4_radix.tex \
	e5_imbalance.tex \
	e6_communication.tex \
	e7_bytes.tex \
	e8_weak.tex \
	e9_strong.tex \
	e10_cuda_efficiency.tex
INCLUDED_FIGS = figs/task-bench-results/compute/flops_stencil_mpi.pdf \
	figs/task-bench-results/compute/efficiency_stencil_mpi.pdf \
	figs/task-bench-results/compute/weak_mpi.pdf \
	figs/task-bench-results/compute/strong_mpi.pdf \
	figs/task-bench-results/compute/flops_stencil.pdf \
	figs/task-bench-results/compute/efficiency_stencil.pdf \
	figs/task-bench-results/compute/metg_stencil.pdf \
	figs/task-bench-results/compute/metg_nearest.pdf \
	figs/task-bench-results/compute/metg_spread.pdf \
	figs/task-bench-results/compute/metg_ngraphs_4_nearest.pdf \
	figs/task-bench-results/radix/metg_nearest.pdf \
	figs/task-bench-results/imbalance/efficiency_imbalance_0.5.pdf \
	figs/task-bench-results/imbalance/efficiency_imbalance_1.0.pdf \
	figs/task-bench-results/imbalance/efficiency_imbalance_1.5.pdf \
	figs/task-bench-results/imbalance/efficiency_imbalance_2.0.pdf \
	figs/task-bench-results/communication/efficiency_nodes_64_comm_16.pdf \
	figs/task-bench-results/communication/efficiency_nodes_64_comm_256.pdf \
	figs/task-bench-results/communication/efficiency_nodes_64_comm_4096.pdf \
	figs/task-bench-results/communication/efficiency_nodes_64_comm_65536.pdf \
	figs/task-bench-results/memory/bytes_stencil.pdf \
	figs/task-bench-results/compute/weak.pdf \
	figs/task-bench-results/compute/strong.pdf \
	figs/task-bench-results/cuda_compute/flops_normalized_stencil.pdf
GENERATED_FIGS = figs/sample-task-graphs/trivial.pdf \
	figs/sample-task-graphs/no_comm.pdf \
	figs/sample-task-graphs/stencil.pdf \
	figs/sample-task-graphs/fft.pdf \
	figs/sample-task-graphs/dom.pdf \
	figs/sample-task-graphs/tree.pdf

.PHONY: all
all: $(DOC).pdf

$(DOC).pdf: $(DOC).tex bibliography.bib $(INCLUDED_TEX) $(INCLUDED_FIGS) $(GENERATED_FIGS)

$(DOC).pdf: %.pdf: %.tex bibliography.bib
	pdflatex -halt-on-error $*.tex
	(if grep -q bibliography $*.tex; \
	then \
		bibtex $*; \
		pdflatex -halt-on-error $*.tex; \
	fi)
	pdflatex -halt-on-error $*.tex

$(GENERATED_FIGS): %.pdf: %.tex
	cd $(dir $*) && pdflatex -halt-on-error $(notdir $*.tex)

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
	(cd figs/task-bench-results/radix && ../../task-bench/scripts/render_all.sh crop)
	(cd figs/task-bench-results/memory && ../../task-bench/scripts/render_all.sh crop)
	(cd figs/task-bench-results/cuda_compute && ../../task-bench/scripts/render_all.sh crop)

.PHONY: spelling
spelling:
	for f in *.tex; do aspell -p ./aspell.en.pws --repl=./aspell.en.prepl -c $$f; done

.PHONY: clean
clean:
	rm -f *.bbl *.aux *.log *.out *.blg *.lot *.lof *.dvi $(DOC).pdf $(DOC)-ext.pdf $(GENERATED_FIGS)
	cd figs/sample-task-graphs && rm -f *.bbl *.aux *.log *.out *.blg *.lot *.lof *.dvi

.PHONY: zip
zip:
	zip -r task_bench.zip *.tex *.cls Makefile *.sty *.bib
