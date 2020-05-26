# Detailed Comments for Authors

Task Bench is a framework designed to implement benchmarks that are portable across a broad range of HPC programming systems. The benchmark is specified on an abstract level in terms of its computation and communication patterns and implemented using a runtime API, for which various programming-system specific implementations exist. This means although the benchmark is provided as a single source, for its execution the developer can choose among 15 programming systems, including very popular ones such as MPI+X and OpenMP.

The purpose of Task Bench is to study the scalability of programming systems when exposed to various computation and communication patterns. To this end, the authors introduce another metric called METG, which measures the minimum task size to achieve 50% of peak performance. In the evaluation, the paper compares the scalability of the supported programming systems using a set of benchmarks representing different patterns, also paying attention to task overhead. Moreover, the paper discusses case studies in which Task Bench was successfully deployed to identify performance bottlenecks in programming systems.

Unfortunately, the motivation oversells the contribution, as it claims to simplify the development of mini-apps. Mini-apps are stripped-down versions of real applications. For this reason, they inevitably inherit the programming system of their parents. As the authors rightfully assert, adapting a set of x mini-apps to y other programming system, requires an effort proportional to O(xy). However, the benchmarks constructed with Task Bench are rather synthetic, only far remotely related to real applications. This limits the relevance of the work to a framework for the performance evaluation of programming systems based on micro-benchmarks. I noticed that the conclusion is much more modest in this regard than the introduction.

The evaluation in Section V shows the usefulness of the METG metric, but the results are rather unsurprising. It is pretty obvious that the different programming systems favor different degrees of task granularity, including the difference between synchronous and asynchronous systems. Regrettably, the authors devoted only little space to actual use cases. The performance optimization of Realm and Chapel covers only ten lines, making it very hard to understand how exactly it profited from Task Bench. The remaining case studies are so terse that it is hard to believe that Task Bench had any real impact.

Some minor comments:

Weak and strong scaling are no metrics.

I didn’t understand what it means that the Task Bench core library is fully validating. What exactly is being validated?

Could you please better explain the notion of the “most parallel efficient job size (ratio of benchmark speed-up vs. linear speed- up above 50%)”? I know, it’s a quote, but a little bit more background would be helpful.

I’m not sure about the statement “In theory, any system should achieve peak performance if the kernels are well-tuned and of sufficiently large granularity.” It is too general to be provable in theory.

# Comments for Revision

Please expand your case studies to better demonstrate the practical impact of Task Bench.
