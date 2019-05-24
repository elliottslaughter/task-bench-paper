We thank the reviewers for their detailed and insightful feedback.

We have added four new implementations to Task Bench: Dask, bulk synchronous MPI,
MPI+OpenMP and MPI+CUDA. Results are included in the evaluation
section, including preliminary results from experiments with GPUs on
the Piz Daint supercomputer.

Major changes in the revised paper:

  * New implementations: Dask, bulk synchronous MPI, MPI+OpenMP and MPI+CUDA
  * New sections
      - Implementation: sections 4.3 (Dask) and 4.5 (MPI+X)
      - Evaluation: sections 5.6 (weak/strong scaling) and 5.9 (GPUs)
  * New figures
      - Listings 1 and 2 (code samples)
      - Figures 11, 12, 15 (experiments)

In response to specific reviewer questions:

Reviewer 1:

The memory bound kernel has been written to perform a varying number
of passes (or partial passes) over a fixed-sized buffer, in order to
keep working set size constant and avoid interference due to cache
effects, which in our opinion makes the results difficult to
interpret.

See the code samples in Listing 1 and 2.

Reviewer 2:

Figures 3 and 4 have been updated and new text added.

Reviewer 3:

Weak/strong scaling and TPS are also application and system dependent
metrics. METG differs from these metrics in that can simultaneously
(a) capture the behavior of the system at the limit of its scalability
(which is not true of weak/strong scaling) and (b) while achieving a
specified amount of useful work (which is not true of TPS). METG also
isolates the impact of changes to the communication topology at scale,
whereas in a strong scaling study this effect would be entangled with
issues of system overhead. Examples of how to compute METG from
application wall time have been added to Section 2.

METG captures the average task granularity that can be supported. It
is acceptable for some tasks to be smaller and others larger, as
overheads will even out across tasks.

A comparison with weak/strong scaling has been added in Section 5.6.

Reviewer 4:

We have added a bulk synchronous implementation in MPI which uses
MPI_Barrier to enforce the boundary between communication and
computation phases. Also, the new MPI+OpenMP implementation also
shares some characteristics with BSP as the OpenMP parallel for
construct acts as an implicit barrier for the cores within a node.

One of the salient features of Task Bench is that it permits the
implementation of a benchmark with M configurations and N systems with
an amount of effort that is O(M+N) rather than O(MN). We have updated
the introduction to reflect this.

The tasks in Task Bench are idealized compute or memory-bound loops;
problem size is simulated by controlling the number of iterations in
these loops. Listing 1 is an example.

Shared memory is permitted and is used in our MPI+OpenMP
implementation (among others).

The code for determining the dependence pattern and implementations of
kernels are contained in the core. A code sample from an
implementation is included in Listing 2. As the reviewer can see,
implementations can be quite simple.

We have added an initial evaluation of MPI+CUDA. Our implementation
uses an offload model in which data is copied to and from the GPU on
each timestep. We find that even when using multiple ranks per GPU to
achieve concurrency in data movement and task scheduling, GPUs
increase the overhead of scheduling small tasks quite substantially.

Reviewer 5:

As described in Section 6, citations [27] and [37] are the only papers
we're aware of which provide an empirical performance evaluation of a
substantial number of systems. Many mini-app and benchmark papers only
include a small number of systems, or describe systems but do not
include an empirical evaluation of performance. When there are
follow-up papers which describe additional implementations, they
rarely make comparisons beyond the reference implementation of the
code.

The output of a task is an array of bytes overwritten with a repeating
pattern (timestep, point). If the input does not match an assertion is
thrown.

Any measure of efficiency can be used with METG. For example, a
mesh-based application could use mesh cells processed per second (as a
percentage of the highest throughput achieved with any problem
size). We use peak performance as the measure of efficiency in Task
Bench because it makes it straightforward to verify that all
implementations are configured correctly.
