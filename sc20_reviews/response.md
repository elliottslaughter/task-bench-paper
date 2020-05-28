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

  * We have clarified the quote about 50% in Section IV.

## Reviewer 5
