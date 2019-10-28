We thank the reviewers for their detailed and insightful feedback.

Task Bench is a new class of benchmark that aims to make it easy to
execute a wide variety of application patterns on a large number of
distributed and parallel programming systems. Despite the name, Task
Bench is not specific to task-based programming models. A "task" in
Task Bench is simply any unit of code that runs to completion without
requiring any network communication. Any application that can be
separated into units of work interleaved with communication can be
adapted to Task Bench.

As a case in point, our MPI implementation is written in an extremely
straightforward style, with interleaved phases of communication and
computation. Each MPI rank is responsible for a set of columns in the
task graph. During communication phases we use non-blocking sends and
receives to communicate task dependencies, and then after calling
`MPI_Waitall()` we execute the corresponding tasks (whose inputs were
just received). We conducted an independent code review of our MPI
implementation with developers of a major MPI implementation to
confirm that the code is written in a manner that is representative of
how real-world MPI users write MPI code, and that it achieves good
performance.

In general, we are confident in the performance of our Task Bench
implementations because each one has been submitted to the developers
of the corresponding systems for code review and suggestions.

Task Bench covers a space of possible application patterns. This space
is easy to extend, e.g. by adding new kernels, dependence patterns, or
by choosing new values for the existing parameters (height, width,
etc.). As can be seen in Listing 2 in the paper, the Task Bench core
API is very general, and includes the ability to include or exclude
arbitrary points within the space (line 17), and to specify arbitrary
dependencies for each point in the task graph (line 19). Note that the
dependence pattern can also change over time; this can be seen in the
FFT and Tree patterns (Figure 1c and e). Thus, while the specific
patterns evaluated in the paper are necessarily limited (as the
reviewers have noted, our evaluation is already extremely
comprehensive), it is entirely possible (and even easy, relatively
speaking) to design patterns and kernels that do reflect actual mini-
or full-size applications in Task Bench.

We believe Task Bench compares very favorably with other benchmarks in
terms of the number of programming system features and behaviors that
it is capable of exploring. Certainly, compared to any benchmark which
is widely implemented, Task Bench provides massively more
expressiveness and configurability. Task Bench provides even more
implementations than the most widely implemented benchmark that we are
aware of. And in terms of the depth of analysis that can be performed,
the only benchmarks that provides substantially more visibility into
system-specific performance behaviors are themselves system-specific.

Task Bench is open source and we intend for it to be an active project
which is open to contribution. In fact, since the initial submission
of the paper we added three new functionally correct implementations
to Task Bench. If these implementations are tuned to our satisfaction
in advance of the deadline they will be included in the final paper.

METG is not fundamentally tied to peak performance (FLOP/s or B/s). If
an application is not amenable to being characterized via peak
performance, another measure of absolute performance can be used. For
example, an aerodynamics application might choose mesh cells processed
per second. The value of 100% efficiency would be set to the highest
throughput that can be achieved on a single node. Other values of
efficiency can be computed as the ratio of that highest throughput
achieved.

Though our evaluation uses METG(50%), this is not a limitation of
METG. We chose 50% because it avoids certain pathologies associated
with low efficiency thresholds (see lines 711-750 in the paper), and
also because it matches what we see implemented in practice. For
example, in a CSCS application for new projects, users are instructed
to "select the most parallel efficient job size (ratio of benchmark
speed-up vs. linear speed-up above 50%)" \[1]. This corresponds to 50\%
parallel efficiency.

\[1]: https://user.cscs.ch/access/report/

In the interest of answering the reviewers' questions as completely as
possible, we include responses to specific reviewer questions below.

## Reviewer A

  * See above for our description of the MPI implementation. A "task"
    in MPI includes the time to execute a set of send/receive calls
    needed to gather the inputs for a given task invocation, the call
    the core API to execute the task.

## Reviewer B

  * In our MPI+OpenMP configuration we use `OMP_NUM_THREADS` equal to
    the number of physical cores on the node (32 on Cori Haswell). In
    general this is set on a per-system basis depending on what is
    most representative of how the system is used in practice.

  * Overlap occurs when there is task parallelism available in the
    task graph. That is, when two tasks are independent (no mutual
    dependencies) their execution can be overlapped with the other's
    data transfers.

## Reviewer C

  * Note that there is an evaluation of trivial dependencies in Figure
    10. Trivial corresponds to 0 dependencies per task in this chart.

  * Note that in Figure 10 Task Bench achieves running times per task
    as small as 390 ns (while still maintaining 50% efficiency). In
    general Task Bench is carefully written to be as optimal as
    possible (e.g. avoiding memory allocations), both in the core API
    and in the implementations themselves. Lines 343-347 describe our
    evaluation of the validation overhead of Task Bench.

# Reviewer D

  * Please see lines 1158-1187 for insights enabled by Task Bench.

  * Task Bench covers a wide variety of features, and does so for
    every programming system that it implements. We believe this
    compares favorably against traditional benchmarks which
    necessarily cover only a subset of features, and typically are
    implemented for only a limited number of programming systems.

  * As described in lines 711-750, measuring overhead alone is prone
    to certain pathologies in evaluation which can make the results
    unrepresentative. For this reason we prefer to use METG(50%) as a
    more representative measure. However, an interested reader can see
    Figure 7: the value at 0% efficiency is by definition the overhead
    of the system (as no useful work is being performed).

  * We do not have hardware metrics at this time but consider this a
    good direction for future work.

# Reviewer E

  * We provide separate kernel implementations for CPU and GPU.

  * See above for a description of the MPI implementation. The Dask
    implementation (which is representative of implicitly parallel
    systems) is shown in Listing 2.

  * Compare Figures 7 and 8. In Figure 7, the spread between systems
    (at the highest efficiency achieved by each system) is larger,
    because some systems reserve cores for internal use. With the
    exception of OmpSs (which we are investigating), this gap is not
    present in Figure 8.

  * A number of slower systems are challenging to run within the time
    limit; TensorFlow is one of these.

  * Regarding task granularity, \[2] describes data analytics
    platforms as executing tasks that "complete in hundreds of
    milliseconds". Note this is after optimizations to the scheduler
    to enable more fine-grained tasks, and task granularity is
    specifically cited as a challenge in scaling such systems. In
    contrast, \[3] (related work section) describes typical HPC
    systems that execute millisecond granularity tasks or smaller.

    \[3] Kay Ousterhout, The Case for Tiny Tasks in Compute Cluster,
    HotOS13.

    \[2]: Reazul Hoque, et al., Dynamic Task Discovery in PaRSEC - A
    Data-flow Task-based Runtime, ScalA17.
