We thank the reviewers for their insightful feedback.

Reviewers A and D note that the bugs described in lines 197-199
currently do not have a larger analysis. We include a draft of this
analysis below and will incorporate it into the final paper.

Regarding novelty, reviewer C is correct that a major contribution of
our paper is a thorough empirical evaluation, but that this is made
possible by substantial contributions in other areas. Namely, the
design of task bench which permits $\mathcal{O}(N+M)$ rather than
$\mathcal{O}(NM)$ implementation effort, and the definition of METG,
are both critical. Without the former, a comparison of 15 systems
would be intractable without substantially simplifying the
benchmark. Without the latter, the results would be prone to bias, and
even more difficult to interpret.

Contrary to the suggestion of reviewer A, we found that the METGs we
found in practice did not always match our intuitions. In fact, some
were off to such a large degree (multiple orders of magnitude) that
they prompted the development teams to conduct major new development
to address our results. These cases are included in our analysis
below.

It is true that METG is a configuration-specific metric. That is, it
can vary depending on the network, CPU, etc. However it is our
experience that METG for a given programming system tends to span a
range of typical values, and that these can guide both application and
system development. Also, more precise measurements can identify
specific bugs as noted above.

Reviewer B asks about the impact of the network. It is our experience
that, except at the absolute lowest METGs, most programming system
overhead is on the CPU. Thus our study can highlight ways in which
these systems can be optimized to reduce unnecessary
overheads. However, we agree that a comparison across network
architectures would be a good direction for future work.

TPS is reported in citations \[6, 28, 32].

Fitting a Task Bench configuration to a specific application is a
direction for future work, but the patterns in Figure 1 are all
derived from common scientific computing workloads (and this is an
extensible set).

Irregular parallelism is enabled by allowing dependencies to vary over
time. For example, the full Task Bench implementation includes a
random dependence pattern.

The OpenMP implementation uses a switch to execute `#pragma omp task`
statements with varying numbers of `depends` clauses. An excerpt is
included below. Note all our implementations are open source and a
link will be included in the final paper.

Responding to reviewer C: the task graph is streamed whenever
possible. For example, both Realm and Dask operate on explicit task
graphs, but Realm is streamed (the API permits executing one chunk of
the graph while the next is being constructed), whereas Dask requires
the entire graph to be constructed. But see also our note on Dask
below.

Problem size corresponds to the `iterations` parameter to Listing
1. Note that since these are idealized kernels, what matters is the
total number of FLOPs executed, which directly corresponds to
`iterations`.

We use weak scaling. Height is fixed at 1000 (so the duration of the
run remains constant) while width varies with the number of
processors.
