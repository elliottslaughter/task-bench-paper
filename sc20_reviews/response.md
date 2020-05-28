We thank the reviewers for their detailed and insightful feedback.

Changes made in response to reviewer comments:

  * Added Section V.G: Load Imbalance.
  * Expanded Section VI: Performance Issues Discovered.
  * Minor additional clarifications described below.

Responding to reviewer questions:

## Reviewer 1

  * Task graphs can be arbitrary, including irregular graphs. We added an example to Figure 1.

  * METG has already proven useful for exposing behaviors at the limits of system performance. We updated Section VI to provide additional details.

  * Our experiments are chosen to span the entire range of task granularities, from very efficient (low overhead) to inefficient (high overhead). METG naturally determines the point at which runtime overheads come to dominate application execution. We find empirically that the most efficient systems have METG(50%) values ranging from about 5 us to about 100 us depending on the scale and dependency pattern, when data movement per dependency is small. Keep in mind that this is the *limit* of what the system can achieve; not all applications will require tasks so fine-grained. Also, as noted in the paper, clearly there are popular and widely used systems on both ends of this spectrum; some classes of applications can tolerate much larger task granularities.

  * For a specific example of an application where small task granularities are useful, see https://ieeexplore.ieee.org/document/8948618. Figure 2 shows that with a tile size of 1024 the algorithm achieves about 7 TFLOPS/s. The task executed on each tile is a straightforward matrix multiply, making it easy to determine the the FLOPS (and therefore task granularity): (2\*1024\*1024\*1024/10^9)/7000gflops = 307us.

## Reviewer 2

## Reviewer 3

  * We added commit IDs to Table 5.

  * We renamed Section VI.

  * We added the Deakin citation to our related work.

## Reviewer 4

  * Text has been added to Section II to clarify validation.

  * We clarified the quote about 50% in Section IV.

  * We clarified the paragraph at the top of Section V.A.

  * We expanded Section VI.

## Reviewer 5

  * Whether dependencies are constructured ahead of time or on the fly is a feature of a specific implementation of Task Bench, not the core API.

    FIXME: Add note about added Dask/TensorFlow impls, or whether we add more text, or whatever.

  * We added Section V.G.

  * Figure 11 is comparable to Figure 3. As described in the text, Figure 3 is generated from Figure 2 by computing, for each data point, efficiency and task granularity. These are derived metrics, resulting in a parametric graph. Intuitively, there is a data point per problem size, but task granularity does not necessarily decrease with problem size. This view makes it intuitive how efficiency and task granularity are related.

  * We use MPS in the case of MPI with 4 ranks per GPU. Our code uses an offload model where any communicated data is copied to and from the GPU for each task execution; this is an intentional decision to model the most common way in which MPI+CUDA is used. Using 4 ranks per node allows the copies to/from the GPU and kernel launches to be performed in parallel, increasing the utilization of the GPU (at the cost of higher overheads at small task granularities). All of these factors, including the kernel launch latency, are included in our task granularity measurements.
