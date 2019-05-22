We thank the reviewers for their detailed and insightful feedback.

We have added three new implementations to Task Bench: Dask,
MPI+OpenMP and MPI+CUDA. Results are included in the evaluation
section.

One of the salient features of Task Bench is that it permits the
implementation of a benchmark with M configurations and N systems with
an amount of effort that is O(M+N) rather than O(MN). We have updated
the introduction to reflect this.

Any measure of efficiency can be used with METG. For example, a
mesh-based application could use mesh cells processed per second (as a
percentage of the highest throughput achieved with any problem
size). We use peak performance with Task Bench as it gives us a
straightforward measure that provides assurance that all
implementations are configured correctly.

In response to specific reviewer questions:
