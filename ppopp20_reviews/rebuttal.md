We thank the reviewers for their feedback.

TaskBench is a new class of benchmark that makes it easy to
execute a wide variety of application patterns on a large number of
distributed and parallel programming systems. Despite the name, TaskBench is not specific to task-based programming models. A "task" in
TaskBench is simply any unit of code that runs to completion without
requiring network communication. Any application that can be
separated into units of work interleaved with communication can be
adapted to TaskBench.

As a case in point, our MPI implementation is written in a
straightforward style, with interleaved phases of communication and
computation. A code excerpt is included below and will appear in the
final paper. We conducted an independent code review of our MPI
implementation with developers of a major MPI implementation to
confirm that the code is written in a manner that is representative of
how real-world MPI users write MPI code, and that it achieves good
performance.

In general, we are confident in the performance of our TaskBench
implementations because each one has been submitted to the developers
of the corresponding systems for code review and suggestions.

TaskBench covers a space of application patterns. This space is easy
to extend, e.g. by adding kernels, dependence patterns, or by choosing
new values for existing parameters (height, width, etc.). In the Dask
implementation in Listing 2 in the paper (and MPI below), methods and
fields of graph `g` are provided by the core API. This API is very
general, and includes the ability to include or exclude arbitrary
points (`contains_point()`), and to specify arbitrary dependencies for
each task (`dependencies()`). Note that dependencies can also change
over time (see Figure 1c and 1e). Thus, while the specific patterns
evaluated in the paper are necessarily limited (as the reviewers have
noted, our evaluation is very comprehensive), it is entirely possible
(and even easy, relatively speaking) to design patterns and kernels
that do reflect actual mini- or full-size applications in TaskBench
(and switch between patterns over time as the application moves
between different phases of computation).

We believe TaskBench compares very favorably with other benchmarks in
terms of the programming system features and behaviors it's capable of
exploring. Compared to any widely implemented benchmark, TaskBench
provides substantially more expressiveness and configurability, while
offering even more implementations thanks to its ease of porting to
new systems. And in terms of the depth of analysis that can be
performed, while we certainly do not mean to claim that TaskBench can
do everything, the only benchmarks that provide substantially more
visibility into system-specific performance behaviors are themselves
system-specific.

TaskBench is open source and we intend for it to be an active project
which is open to contribution. In fact, since the initial submission
of the paper, we added three new functionally correct implementations
to TaskBench. If these implementations are tuned to our satisfaction
in advance of the deadline they will be included in the final paper.

METG is not fundamentally tied to peak performance, nor is it specific to TaskBench. If
an application is not amenable to being characterized via peak
performance, another measure of absolute performance can be used. For
example, an aerodynamics application might choose mesh cells processed
per second. The value of 100% efficiency would be set to the highest
throughput that can be achieved on a single node. Other values of
efficiency can be computed as the ratio of that highest throughput
achieved.

Though our evaluation uses METG(50%), this is not a limitation of
our technique. We chose 50% because it avoids certain pathologies associated
with low efficiency thresholds (see lines 711-750 in the paper), and
also because it matches what we see in practice. For
example, in a CSCS application for new projects, users are instructed
to "select the most parallel efficient job size (ratio of benchmark
speed-up vs. linear speed-up above 50%)" \[1]. This corresponds to 50%
efficiency.

\[1]: https://user.cscs.ch/access/report/

A simplified excerpt from our MPI implementation follows.

```
void execute_task_graph(Graph g) {
  char *output = (char *)malloc(g.output_bytes_per_task);
  char *scratch = (char *)malloc(g.scratch_bytes_per_task);
  char **inputs = (char **)malloc(g.max_dependencies_per_task * sizeof(char *));
  char *input_bytes = (size_t *)malloc(g.max_dependencies_per_task * sizeof(size_t));
  long num_inputs;

  long rank;
  std::vector<long> rank_by_point; // maps points to ranks
  std::vector<MPI_Request> requests;

  // initialize data structures...

  for (long t = 0; t < g.height; ++t) {
    if (g.contains_point(t, rank)) {
      num_inputs = 0;
      requests.clear();

      for (long dep : g.dependencies(t, rank)) {
        MPI_Request req;
        MPI_Irecv(
          inputs[num_inputs], input_bytes[num_inputs], MPI_BYTE,
          rank_by_point[dep], 0, MPI_COMM_WORLD, req);
        requests.push_back(req);
        num_inputs++;
      }

      for (long dep : g.reverse_dependencies(t, rank)) {
        MPI_Request req;
        MPI_Isend(
          output, g.output_bytes_per_task, MPI_BYTE,
          rank_by_point[dep], 0, MPI_COMM_WORLD, req);
        requests.push_back(req);
      }

      MPI_Waitall(requests.size(), requests.data(), MPI_STATUSES_IGNORE);

      g.execute_point(
        t, rank,
        output, g.output_bytes_per_task,
        inputs, input_bytes, num_inputs,
        scratch, g.scratch_bytes_per_task);
    }
  }
}
```

In the interest of answering reviewers' questions as completely as
possible, we include responses to specific reviewer questions below.

## Reviewer A

  * See our MPI excerpt above. A "task" in MPI includes the time to
    execute one point in the task graph (i.e. one iteration of the `t`
    loop).

## Reviewer B

  * The core API describes what to do but not how to do
    it. Implementations are permitted to select the strategy that is
    most efficient for a given machine. For example, our MPI+OpenMP
    implementation uses shared memory within a node and uses MPI only
    for inter-node communication. A similar strategy could be applied
    to fat-node architectures such as Summit.

  * Our MPI+OpenMP experiments set `OMP_NUM_THREADS` to the number of
    physical cores on the node (32 on Cori Haswell). In general these
    system-specific settings are chosen to optimize performance while
    remaining faithful to what is representative of real-world usage.

  * Note that METG is not a per-link statistic but characterizes the
    programming system's overall ability to make effective use of a
    machine. The "two weights" are already taken into account with
    e.g. MPI+OpenMP and shared memory.

  * The opportunity for overlap occurs when two tasks are independent
    (have no mutual dependencies). This occurs whenever multiple task
    graphs are used (Figures 9d, 11). Our design also permits
    this to be included in the dependence pattern itself, though we do
    not explore this approach in the paper.

## Reviewer C

  * Please see the MPI excerpt above, and also note Listing 2 in the
    paper shows a Dask implementation.

  * There is an evaluation of trivial dependencies in Figure 10.
    Trivial corresponds to 0 dependencies per task in this chart.

  * Figure 10 TaskBench achieves running times per task as small as
    390 ns (while still maintaining 50% efficiency). In general
    TaskBench is carefully written to be as optimal as possible
    (e.g. avoiding memory allocations), both in the core API and in
    the implementations themselves. Lines 343-347 describe our
    evaluation of the validation overhead of TaskBench.

## Reviewer D

  * Please see lines 1158-1187 for insights enabled by TaskBench.

  * TaskBench covers a wide variety of features (compute/memory
    bound, varying task duration, task graph width and height,
    dependence pattern, communication per task, etc.). TaskBench is
    designed so that every feature is supported on every programming
    system. We believe this
    compares favorably against traditional benchmarks which
    necessarily cover only a subset of features, and typically are
    implemented for only a limited number of programming systems.

  * As described in lines 711-750, measuring overhead alone is prone
    to certain pathologies in evaluation which can make the results
    unrepresentative. For this reason we prefer to use METG(50%) as a
    more representative measure. However, an interested reader can see
    Figure 7: the value at 0% efficiency is by definition the overhead
    of the system (as no useful work is being performed, any remaining time is pure overhead).

  * We do not have hardware metrics at this time but consider this a
    good direction for future work.

## Reviewer E

  * We provide separate, optimized kernel implementations for CPU and
    GPU. Note the precise computation performed by the kernel is not
    relevant; what is important is the computational behavior (compute
    or memory bound), duration, and the amount of data touched, all of
    which are fully configurable.

  * See the MPI excerpt above (which is explicitly parallel), and the
    Dask implementation in Listing 2 (which is implicitly parallel).

  * Compare Figures 7 and 8. In Figure 7, the spread between systems
    (at the highest efficiency achieved by each system) is larger,
    because some systems reserve cores for internal use. With the
    exception of OmpSs (which we are investigating), this gap disappears in Figure 8.

  * A number of slower systems are challenging to run within the time
    limit; TensorFlow is one of these.

  * Regarding task granularity, \[2] describes data analytics
    platforms as executing "tiny" tasks that "complete in hundreds of
    milliseconds", implying that traditional task granularities in this domain are larger. Note this is after scheduler optimizations 
    that enable more fine-grained tasks. In
    contrast, \[3] (related work) describes typical HPC
    granularities in the millisecond range.

    \[2] Kay Ousterhout, The Case for Tiny Tasks in Compute Cluster,
    HotOS13.

    \[3]: Reazul Hoque, et al., Dynamic Task Discovery in PaRSEC - A
    Data-flow Task-based Runtime, ScalA17.
