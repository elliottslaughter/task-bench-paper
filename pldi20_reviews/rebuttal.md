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

TPS is reported in citations \[6, 28, 32]. See also \[A-C] below.

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

MPI p2p is the implementation shown in Listing 2.

## Analysis of Performance Bugs Found

Realm and Chapel use DMA subsystems that are optimized for large
copies. Early Task Bench experiments revealed high METG values that
were diagnosed by the Realm/Chapel developers as overhead due to the
cost of scheduling small copies. Subsequent improvements in Realm and
Chapel improved small copy overheads (and thus METG) by over an order
of magnitude in the case of Realm, and by 2x in the case of
Chapel. These improvements affect any application where fine-grained
tasks are used.

PaRSEC uses a task pruning algorithm to improve scalability at large
node counts. Initial Task Bench results achieved less than the
expected scalability: METG was rising too quickly with node
count. This was diagnosed by the PaRSEC developers as a bug in task
pruning, and subsequently fixed. We also implemented a version of the
PaRSEC code, `shard`, which uses manual pruning to demonstrate that
additional gains may be possible.

Early Task Bench results for Dask revealed that the cost of scheduling
a task was $\mathcal{O}(N)$ where $N$ is the number of tasks in a task
graph, causing overall cost for a task graph with $N$ nodes to be
$\mathcal{O}(N^2)$. This issue was reported to and confirmed by the
Dask developers. As a work around, our result in the paper use a
lower-level interface which does not suffer from this asymptotic
slowdown.

Initial experiments with TensorFlow revealed that the TensorFlow Task
Bench implementation was not able to use all cores on a node (thus
making it impossible to measure METG since the code did not pass the
efficiency threshold). This was diagnosed by the TensorFlow developers
as an issue in constant folding. The entire Task Bench task graph was
being detected as constant, and the constant-folding pass runs on one
core. As a workaround, the developers suggested marking the task graph
inputs as non-constant so that TensorFlow's normal task scheduler
could be used.

## OpenMP Code Excerpt

```c++
void issue_task(Graph g, long t, long p,
                char *output,
                char **inputs, long num_inputs,
                char *scratch) {
  switch (num_inputs) {
  case 1:
    {
      #pragma omp task depend(inout: output) depend(in: inputs[0]) depend(inout: scratch)
      g.execute_point(t, p, output, inputs, scratch);
    }
    break;
  case 2:
    {
      #pragma omp task depend(inout: output) depend(in: inputs[0]) depend(in: inputs[1]) depend(inout: scratch)
      g.execute_point(t, p, output, inputs, scratch);
    }
    break;
  // ...
  }
}

void execute_task_graph(Graph g) {
  char **outputs = (char **)malloc(g.width * sizeof(char *));
  char **scratch = (char **)malloc(g.width * sizeof(char *));
  char **inputs = (char **)malloc(g.width * sizeof(char *));
  char ***input_ptrs = (char ***)malloc(/* ... */);
  // initialize data structures...

  for (long t = 0; t < g.height; ++t) {
    for (long p = 0; p < g.width; ++p) {
      if (g.contains_point(t, p)) {
        long idx = 0;
        for (long dep : g.deps(t, p)) {
          input_ptrs[p][idx] = inputs[dep];
          idx++;
        }

        issue_task(g, t, p, outputs[p], input_ptrs[p], idx, scratch[p]);
      }
    }
    std::swap(inputs, outputs);
  }
}
```

## Additional Citations

\[A]: Mashayekhi, Omid, Hang Qu, Chinmayee Shah, and Philip
Levis. "Execution Templates: Caching Control Plane Decisions for
Strong Scaling of Data Analytics." In 2017 USENIX Annual Technical
Conference (USENIX ATC 17), pp. 513-526. 2017.

\[B]: Moritz, Philipp, Robert Nishihara, Stephanie Wang, Alexey
Tumanov, Richard Liaw, Eric Liang, Melih Elibol et al. "Ray: A
Distributed Framework for Emerging AI Applications." In 13th USENIX
Symposium on Operating Systems Design and Implementation (OSDI 18),
pp. 561-577. 2018.

\[C]: Sadooghi, Iman, Geet Kumar, Ke Wang, Dongfang Zhao, Tonglin Li,
and Ioan Raicu. "Albatross: An Efficient Cloud-Enabled Task Scheduling
and Execution Framework Using Distributed Message Queues." In 2016
IEEE 12th International Conference on e-Science (e-Science),
pp. 11-20. IEEE, 2016.
