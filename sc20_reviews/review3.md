# Detailed Comments for Authors

The title of the submission summarizes the paper quite well: the authors present a new parameterized benchmark, named Task Bench, which allows to evaluate parallel runtime performance. In contrast to other benchmark sets where a set of N benchmarks would have to be implemented for M programming systems, requiring N*M implementations, Task Bench provides a common tasking framework which only needs N implementations of the benchmarks and M implementation of the programming system drivers (N+M) which greatly reduces the amount of implementations necessary to evaluate the performance of different programming systems for different applications. In addition, through parametrization, Task Bench enables a wide variety of benchmark scenarios to investigate key properties and characteristics of large applications.

The authors used Task Bench to evaluate 15 different programming systems. During their extensive evaluation, they found multiple performance bottlenecks in several programming systems which were acknowledged by their developers and fixed in new releases, improving all applications using this system. Finally, they introduce a new metric "minimum effective task granularity" (METG) which can better characterize the performance of task-based applications than currently used metrics like "tasks per second" (TPS).

The paper is very well written and structured. It is easy to read and understand.

The authors first introduce the and motivate the problem, however their contribution presented in this paper could be expressed more explicitly.

The design and implementation of the system is described in detail just on the right level. They shortly describe the 15 programming systems (Chapel, Charm++, Dask, MPI, MPI+Threads/CUDA, OmpSs, OpenMP, PaRSEC, Realm, Regent, Spark, StarPU, Swift/T, Tensorflow, X10) covering traditional HPC programming models, PGAS and Actor models, Task-based Models, as well as DA and ML Workflow systems. The METG metric introduced and discussed in detail.

They performed extensive experimental evaluations of all 15 programming systems, mostly on Cori (8192 cores) and PizDaint for GPU based models evaluating the aspects compute kernel performance, memory kernel performance, baseline overhead, scalability, number of dependencies, overlapping communication and computation, and heterogeneous processors.

# Comments for Revision

I only have a few minor comments:

* Table 5: the "git xxx branch" as version is not very helpful. I am aware that this is a shortcoming of git, but you could try to make it more precise by providing a timestamp when you accessed the branch (for reproducibility)

* The name of Section VI "Case Study" is misleading as the section is not about various (case) studies with Task Bench. Perhaps you could call it "Detected Performance Issues"

* Finally, I miss the work of Prof Simon McIntosh's group which compared five mini-apps implemented for OpenMP, OpenACC, SYCL, KOKKOS, OpenCL, CUDA on 12 artictecures:

T. Deakin et al., "Performance Portability across Diverse Computer Architectures," 2019 IEEE/ACM International Workshop on Performance, Portability and Productivity in HPC (P3HPC), Denver, CO, USA, 2019, pp. 1-13, doi: 10.1109/P3HPC49587.2019.00006.
