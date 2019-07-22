# Detailed Comments for Authors

This paper presents Task Bench, a parameterized benchmark enabling the
performance characterization of various parallel programming models
and systems. Task Bench seeks to reduce the effort required to develop
benchmarks for each parallel platform and to allow for performance
comparisons across systems. The metric used for cross-platform
performance quantification is the METG metric, or the minimum
effective task granularity, which is the minimum task size for which
the programming system can achieve 50% performance efficiency. In this
way, the overheads associated with each parallel programming system
can be quantified; the higher the overheads, the larger the METG
metric. Characteristics such as the number of dependencies and the
ratio of computation to communication can be parameterized.

The experimental evaluation section evaluates a number of these
parameters for stencil and nearest neighbor communication
patterns. What would be useful to see is an analysis with a BSP style
model. While asynchronous task graphs are relevant in many domains,
there are many codes that require bulk-synchronization between phases
of computation. In addition, while the promise of a parameterizable
benchmark lies in the reduction of programming effort relative to
developing proxy-applications for each programming system, the authors
do not devote any attention to this aspect. Some way to quantify the
improved productivity would have helped to make the case for why Task
Bench is useful. The performance results presented are a small
sampling of the combinatorial explosion of parameter values, but they
do not yield generalizable insight.

Some specific points include:

  - In Figure 1, it is not clear what is meant by "problem size". Is
    this the number of tasks?

    Units on the x-axis would help this figure.

  - It is not clear how to interpret Figures 3 and 4. A legend might
    help here. The graphs are so dense that it may help readability to
    not include all of the data.

  - How are dependencies between tasks defined for tasks that are
    co-scheduled on the same processor? Do all dependencies result in
    messages or can shared memory be used (depending on the
    programming system under study)

  - I would like to see more discussion of the architecture of Task
    Bench itself. How much of the benchmark needs to be rewritten for
    each programming system?

  - Can Task Bench be extended to use accelerators (e.g., CUDA for
    multi-GPU nodes)

  - A lot of space in Section 4 is devoted to describing the parallel
    programming systems. Would it be easier and more concise to simply
    highlight the relevant characteristics that make each one unique
    or interesting?


# Comments for Revision

I would like to see how Task Bench can handle accelerator-based
programming models, such as MPI+X. Such hierarchical models are common
for HPC applications, but this paper does not address them.