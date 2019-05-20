# Detailed Comments for Authors

The paper describes Task Bench, which is a test program parameterized
by data size, task count, dependence pattern (parallelism), and
granularity. It is programmed in 13 languages/systems from OpenMP, MPI
to X10, with 88 to 1500 lines in each implementation. The Task Bench
core library handles input/parameter parsing, result validation and
output.

The Task Bench evaluates the 13 implementations for CPU and memory
bound tasks, number of dependences, baseline overhead, scalability,
load imbalance, and communication hiding.

While the main findings are expected, i.e. Spark has most overhead and
MPI has least, the evaluation shows quantitatively how 13 different
systems compare with each other, which is quite novel.

The metric Minimum effective task granularity METG is a good invention
and shown useful and effective in measuring the baseline overhead.


# Comments for Revision

The last paragraph in Section 3 describes the memory-bound kernel as
one making array traversals. It says that "the duration ... can be
configured by setting the number of iterations ... we use this ability
to simulate ... program sizes." I'd think that the program size is
simulated by the array size, not the number of iterations. Please
specify.

In general, the paper should be more clear about the specifics of the
design. Can you specify Task Bench in pseudo code? For precision and
completeness, the paper can show a list of all Task Bench parameters
and then the pseudo code to show exactly how they are used, e.g. what
input parameters are used to determine the array size?
