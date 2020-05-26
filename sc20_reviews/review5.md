# Detailed Comments for Authors

The paper proposes a benchmark framework which provides a task graph abstraction consisting of vertices (tasks) and edges (communication or synchronization). Different task graphs can be constructed to represent different computational benchmarks. Then a different implementation of vertices and edges can be plugged in for different programming models. The benchmark framework then allows a simpler comparison of the programming models and their limitations then the different proxy apps, which are harder to implement.

While it is interesting to see the performance of different programming models for different granularity sizes, the pitfall of the work is lack of evaluation of whether the model faithfully represents either the computation, or the programming model. More direct evaluation of the individual pairings is necessary - perhaps starting with existing implementations of existing proxy apps in specific programming models.

# Comments for Revision

More details are necessary to understand how you implement different programming models, for example, please specify how task bench differentiates whether the dependence graph is constructed ahead of time or on the fly, and how you deal with dynamic checks.

In section V you state that you would include new results in the final paper. This is not ok, as the results would have to be reviewed before publication. It is unclear where you will get more space to include them anyways.

The lines in Figure 11 are confusing as the do not draw a function. Why did you chose to draw them this way?

Is figure 12 the only GPU result in this paper? Running one vs. 4 MPI tasks per GPU is quite different from the perspective of communication and kernel launch overheads; do you have a better understanding why 4 ranks per GPU is more performant on the larger scale? How did you model kernel launch overhead? Did you use MPS?
