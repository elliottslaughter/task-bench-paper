We thank the reviewers for their detailed and insightful feedback.

Changes made in response to reviewer comments:

  * Added Section V-G: Load Imbalance.
  * Added Section V-I: Predicting Strong Scaling with METG.
  * Expanded Section VI: Performance Issues Discovered.
  * Additional changes requested by specific reviewers are described below.

All changes are marked in blue.

Responding to reviewer questions:

## Reviewer 1

  * Task graphs can be arbitrary, including irregular graphs. We added an example to Figure 1 showing a random graph.

  * METG has already proven useful for exposing behaviors at the limits of system performance. We updated Section VI to provide additional details.

  * Our experiments are chosen to span the entire range of task granularities, from very efficient (large, and low overhead) to inefficient (small, and high overhead). METG naturally determines the point at which runtime overheads come to dominate application execution. What we report in the paper are empirical results: the limit of what each system can achieve. This is a lower bound, and generally, such systems will be efficient as long as tasks are at least that large. Also, as noted in the paper, clearly there are popular and widely used systems on both ends of this spectrum; therefore some classes of applications must be able to tolerate much larger task granularities.

  * For a specific example of an application where small task granularities are useful, see <https://ieeexplore.ieee.org/document/8948618>. Figure 2 shows that with a tile size of 1024 the algorithm achieves about 7 TFLOPS/s per GPU. The task executed on each tile is a straightforward matrix multiply, making it easy to determine the the FLOPS (and therefore task granularity): (2\*1024\*1024\*1024/10^9)/7000gflops = 307us.

## Reviewer 2

  * We added Section V-I. This section validates METG against time to solution. We show that it is possible to use METG, along with a single-node measurement of time to solution, to predict the strong scalability of a code (i.e., the point where it reaches 50% parallel efficiency, in terms of both time to solution, and node count). We find that we can predict time to solution (at 50% efficiency) to within a factor of 1.42X on average across 11 programming systems and 4 Task Bench configurations.

  * We expanded Section V-B and V-C to describe how the properties of the various systems influence our results.

## Reviewer 3

  * We added commit IDs to Table 5.

  * We renamed Section VI.

  * We added the Deakin citation to our related work.

## Reviewer 4

  * Task Bench provides access to a large space of behaviors (kernel computation, load imbalance, shape of the task graph, number of dependencies and their structure, amount of data communicated, etc.). We agree that there are dimensions of this space that are not currently covered by Task Bench, and that are covered by specific mini-apps; we consider this a good direction for future work. In spite of this, the space covered by Task Bench today is already larger than the existing benchmarks, or any single mini-app. Moreover, Task Bench makes it dramatically easier to implement for a wide variety of systems, making comparative study feasible. We have added some clarifications to the introduction.

  * We updated the terminology in the introduction.

  * Text has been added to Section II to clarify validation.

  * We clarified the quote about 50% in Section IV.

  * We clarified the paragraph at the top of Section V-A.

  * We expanded Section VI.

## Reviewer 5

  * We agree that cross-validation with mini-apps is a good direction for future work, but that concrete benefits have already been demonstrated in the form of performance bugs found and fixed via Task Bench (see updated Section VI).

  * Whether dependencies are constructed ahead of time or on the fly is a feature of the programming model being used to implement of Task Bench, not a feature of Task Bench itself. E.g., Dask, PaRSEC, Regent and StarPU all construct the task graph on the fly. The core APIs shown in Table 3 are sufficient to do this, it is simply a matter of calling the right programming model APIs for each task. Listing 2 shows how we do this for MPI. All of our implementations are open source and will be linked in the final paper.

  * We ensure that all core APIs are very efficient, making these checks low-cost so that there is no penalty to querying the APIs on the fly (if that is how the programming model is designed to be used).

  * We added Section V-G.

  * Figure 11 is comparable to Figure 3. As described in the text, Figure 3 is generated from Figure 2 by computing, for each data point, efficiency and task granularity. These are derived metrics, resulting in a parametric graph. Intuitively, there is a data point per problem size, but task granularity does not necessarily decrease with problem size (due to overheads). Noise can also introduce variations in the measurements, especially at higher node counts, and particularly with MPI which uses a model of communicating sequential processes.

  * We use MPS in the case of MPI with 4 ranks per GPU. Our code uses an offload model where any communicated data is copied to and from the GPU for each task execution. Using 4 ranks per node allows the copies to/from the GPU and kernel launches to be performed in parallel, increasing the utilization of the GPU (at the cost of higher overheads at small task granularities). All of these factors, including the kernel launch latency, are included in our task granularity measurements.
