# Detailed Comments for Authors

Comments:
- This paper proposes a suite of mini-apps based on task graphs to compare parallel and distributed programming systems.
- Only regular graphs are supported.
- A new metric, called minimum effective task granularity (METG), is proposed and this metric is the basis of the comparative evaluation. METG is such that METG(50%) is the smallest task granularity that maintains at least 50% efficiency.
- 15 parallel programming environments were evaluated with varied tasks granularities.

Strengths:
- A wide range of parallel programming environments were used in the tests.

Weaknesses:
- Very simple patterns were considered in the tests (stencil, nearest, spread).
- Irregular graphs are not treated
- It is not clear that the supercomputing community will adopt this new metric instead of using the traditional efficiency metric.
- The authors did not justify the range of task granularities used in the experiments. For instance, in a real parallel application for supercomputers is it reasonable to have task granularity lower or equal than 1ms? I would like to have some references to such applications.

# Comments for Revision

- Please justify the use of small task granularity values (lower or equal than 1ms).
