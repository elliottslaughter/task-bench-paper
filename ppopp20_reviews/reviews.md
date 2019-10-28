PPoPP'20 Paper #200 Reviews and Comments
===========================================================================
Paper #200 Task Bench: A Parameterized Benchmark for Evaluating Parallel
Runtime Performance


Review #200A
===========================================================================

Paper summary
-------------
This paper presents TaskBench, a new parametrized benchmark system to evaluate the performance of different parallel run-time environments. The key idea is to separate the system-specific implementation from the implementation of the benchmarks themselves. This allows for a great reduction in complexity in porting N different applications in M distinct computing architectures, making the whole effort linear (N+M instead of N*M).

List of main strengths of the paper
-----------------------------------
-Well presented, with many interesting technical details on the implementation and on the experimental configuration and results.
-The volume of applications considered is large, heterogeneous and comprehensive of several application domains.
-The idea of introducing a new metric to better quantify the overhead of different run-time systems is interesting.

List of major weaknesses of the paper
-------------------------------------
-The scientific novelty per se is quite limited. The paper is almost an experimental analysis of different applications and of their performance in one target parallel system.
-The approach seems to be very tailored to task-based parallel programming frameworks. Although they are a large fraction of the whole set of parallel programming tools, other approaches seem to be excluded from this. The authors sometimes tried to present a wider generality of TaskBench, which can be adapted to other parallel systems without an explicit notion of task. However, I found the description of this part a bit weak and further clarifications should be provided.

Overall merit
-------------
B. OK paper, but I will not champion it

Reviewer expertise
------------------
Y. I am knowledgeable in this area, but not an expert

Short (2-3 sentence) summary of your review explaining your overall merit score
-------------------------------------------------------------------------------
In summary the paper is an experimental work. I was not impressed by its scientific novelty. However, the volume of results is very large and well described and the final insights are interesting. Although without championing it, I would be not against its acceptance if there is available room in the conference program.

Novelty
-------
2. Incremental improvement

Potential for impact
--------------------
3. Moderate Impact: Will influence other efforts

Writing quality
---------------
4. Well-written

Questions for authors’ response
---------------------------------
See the part about the weaknesses that I found during my reading of the paper. I would like to see proper answers to such points during the rebuttal if possible.

Comments to authors
-------------------
The paper tackles a very traditional problem in HPC. Developing benchmarking methodologies is important to compare different run-time systems for parallel computing on a wide variety of parallel computing architecturs. The authors effectively explained the criticisms of micro-benchmarks approaches, and highlighted the complexity of porting new benchmarks on different machines. In this sense, the idea of TaskBench is interesting although not ground-breaking.

The basic abstraction of TaskBench is to represent the application as a task graph, where nodes are computational tasks and arcs are their data dependencies. This model is very popular in HPC, and it is the paradigm adopted in several common parallel runtimes (e.g., OmpSs, OpenMP-4, Intel TBB). In addition to this, the authors presented a new contribution of their approach: instead of quantifying the performance of a benchmark on a given runtime/machine pair using traditional strong/weak scaling metrics, the authors proposed a new metric called "minimum effective task granularity" that better describes the run-time system overhead.

The paper is certainly well written and organized. The flow of the text is always linear, and this helps readibility. The amount of experiments considered is very large and the analysis is often comphrensive and gives a lot of insights into the perfomance of different systems and machines.

I found very interesting Section II with the API of TaskBench shown in some snippents. The idea of presenting an abstract API for building task graphs, which then can be translated into different task graphs executable by different task-based parallel libraries is a nice idea to compare different frameworks in a quite easy-to-use way. My only concern is about the customizability of this approach. Each library has its own low-level configuration parameters (e.g., concurrency limit in Intel TBB FlowGraph, and others) that are framework-specific. How is it possible to optimize the implementation of the same application in the various framework by starting from an abstract API to build the task graph?

The main scientific contribution is to introduce a different metric to evaluate task-based parallel programming frameworks. This is the minimum effective task granularity (METG). I found some sentences of this description a bit difficult to understand. METG is a metric that allows understanding what is the minimum task duration to achieve a given threshold of efficiency. I found a bit difficult to read this metric since it is related to the overall efficiency. What is the maximum expected efficiency for a given application? In most cases the peak limit of the machine is an ideal limit difficult or even impossible to achieve with any framework. The authors should better describe how to define a good application-related performance metric for applications where raw FLOPS are not a good model.

Another point that is not propery described is the idea of first using the task-based parallel paradigm to drive the introduction of the METG metric, and then the generalization to run-time systems where the notion of tasks is not explicitly available (e.g., MPI). What is the equivalent notion of tasks in those frameworks? This part should be extended with further clarifications and example since it is of great importance for stating the generality of TaskBench.

Section V is very well presented. It would be nice to introduce the roofline model to better visualize the behavior of the applications and how far they are from the peak limit of the machine. Since this is strongly related to METG with different efficiencies, this could help to better understand the results.



Review #200B
===========================================================================

Paper summary
-------------
The paper proposes a parameterized, task-graph based benchmark suite that can be used to evaluate 15 task-based execution frameworks. The paper also introduces a new metric called minimum effective task granularity to characterize the efficiency of these frameworks on various distributed platforms.

List of main strengths of the paper
-----------------------------------
a)	The paper proposes a different take at measuring the effectiveness and overhead of task based execution frameworks. THE METG seems to be a reasonable metric that is simple yet configurable (i.e. percentage of system utilization)

b)	The coverage of a huge set of task-based execution schemes (15) is also very helpful for developers who are deciding which framework they want to implement their apps on.

List of major weaknesses of the paper
-------------------------------------
a)	The dependency patterns covered in the paper are more complex in reality, even for applications with structured dependencies (e.g. LUD, QR factorization). Also, they come in many mixed flavors and representing even a mini-app with one single graph pattern is not realistic. 

b)	The approach seems to ignore interconnect latency discrepancies. For example, in a fat-node architecture (e.g. Summit), characterizing the commonly used one GPU per MPI rank + OpenMP approach will simply ignore the two-entirely-different weights of possible edges: the edges between the ranks inside the same node (i.e. NVLINK) and the edges between nodes (i.e. infiniband).

Overall merit
-------------
B. OK paper, but I will not champion it

Reviewer expertise
------------------
X. I am an expert in this area

Short (2-3 sentence) summary of your review explaining your overall merit score
-------------------------------------------------------------------------------
There are a lot of task-based execution schemes and this paper provides a simple yet representative solution to compare the efficiency of these approaches on a given platform.

Novelty
-------
3. New contribution

Potential for impact
--------------------
4. High impact: Will have a major influence on other efforts

Writing quality
---------------
4. Well-written

Questions for authors’ response
---------------------------------
a)	How do the authors ensure that their TaskBench implementation of each of the 15 methods use the underlying API in the most efficient manner?

b)	Why 50% is claimed to be a generally acceptable level of efficiency (i.e. lines 563-564)? Can the authors cite some work on this?

c)	How can a user specify the inter-node vs intra-node parallelism ratio in the given task graphs? For example, what will be the ratio between total MPI ranks and the OpenMP NUM_THREADS (in the OpenMP+MPI approach)?

d)	Is there a way to represent data-transfer / computation overlaps in the graphs?

Comments to authors
-------------------
The focus on characterizing accelerated (GPU-based) task-based execution is very weak. There are many aspects (e.g. transfer/execution overlaps, multi-level parallelism, data movement, fat vs light nodes etc.) where the proposed task-graph based approach will simply fail to represent properly. It may be better to omit GPU based execution entirely in this paper, since it raises more questions than answers…



Review #200C
===========================================================================

Paper summary
-------------
This paper describes Task Bench, a synthetic set of parametrizable benchmarks exhibiting a range of computational patterns (parallel, stencil, fft, etc) and its implementation and evaluation using 15 different parallel runtimes. The evaluation focuses on a metric called "minimum effective task granularity" that indicates the minimum size of a task required such that the system reaches a certain efficiency.

List of main strengths of the paper
-----------------------------------
* Interesting problem  
  Comparing different runtime systems is difficult and Task Bench does a good job comparing some aspects of these systems.
* Implementation and Evaluation  
  Laudable effort to implement and evaluate Task Bench on the different runtime systems to produce an interesting analysis.

List of major weaknesses of the paper
-------------------------------------
* Task Bench details  
  While the paper advertises the runtime independent nature of Task Bench, (too) little details are given about Task Bench itself. The reviewer would have liked to see how the different computational patterns are implemented in Task Bench's runtime agnostic way.
* Focus on task graphs  
  The evaluation focuses entirely on the evaluation of task graphs, primarily the stencil computation pattern. An important class of problems in HPC belong to the "trivial" class, yet have not been evaluated.

Overall merit
-------------
C. Weak paper, though I will not fight strongly against it

Reviewer expertise
------------------
X. I am an expert in this area

Short (2-3 sentence) summary of your review explaining your overall merit score
-------------------------------------------------------------------------------
While the evaluation of the METG is interesting, the description of Task Bench itself is minimal and it remains unclear how other researchers can profit from it.

Novelty
-------
2. Incremental improvement

Potential for impact
--------------------
3. Moderate Impact: Will influence other efforts

Writing quality
---------------
4. Well-written

Questions for authors’ response
---------------------------------
* How exactly are the benchmarks written in a backend-agnostic way?
* How can other researchers use Task Bench? Is it open-source? 
* How can you be sure that the implementation of Task Bench itself is not contributing to the overhead of the runtime system?

Comments to authors
-------------------
The authors have done a fine job implementing a portable benchmark for a wide variety of backends. The reviewer would have liked to see more details on how exactly the different benchmarks are described and executed on the different backends. The evaluation of the METG seems a bit excessive in this regard; dedicating one or two more pages to the description of Task Bench at the expense of the evaluation of METG will make the paper stronger.



Review #200D
===========================================================================

Paper summary
-------------
This paper presents Task Bench, a parameterized benchmark to evaluate different parallel programming models. As the contribution, Task Bench support different task graph patterns, implemented with 15 programming models. A new metric, minimum effective task granularity, is proposed to give a reasonable comparison across different programming models. The experiments on a cluster compare the parallel efficiency, throughput, scalability, and overhead across different programming models.

List of main strengths of the paper
-----------------------------------
+ The implementation of Task Bench on 15 different programming models is valuable.

List of major weaknesses of the paper
-------------------------------------
- More insights are expected from the empirical study.
- Not convinced that Task Bench is general enough to cover every aspect of a given programming model.

Overall merit
-------------
C. Weak paper, though I will not fight strongly against it

Reviewer expertise
------------------
X. I am an expert in this area

Short (2-3 sentence) summary of your review explaining your overall merit score
-------------------------------------------------------------------------------
This paper has incremental novelty. While I can appreciate the engineering work on implementing Task Bench (that's why I'm not strongly against this paper), the insights provided from the experiments can be better explained. I'm not convinced that Task Bench can cover every aspect of a given programming model.

Novelty
-------
2. Incremental improvement

Potential for impact
--------------------
3. Moderate Impact: Will influence other efforts

Writing quality
---------------
3. Adequate

Questions for authors’ response
---------------------------------
I wonder whether the authors obtain any insights about the advantages or disadvantages of any programming models. 

How Task Bench can cover every feature of a given programming mode?

Could the authors compare the overhead of each programming model? The overhead defined here is the time use for executing programming model's code instead of user programs.

I wonder whether the authors have some data collected from the hardware performance monitoring units (PMU). For example, I wonder whether any programming models support task locality optimization, which can be quantified with cache miss metrics.

Comments to authors
-------------------
This paper is ambitious. Evaluating different programming models is an urgent and important topic because there are so many programming models developed and people would like to understand their strengths and weaknesses. However, this paper does not provide enough insights from the experimental study. My main concern is described in the questions for rebuttal. Beside those, I also have some comments:

1. Does Task Bench support any irregular access pattens?
2. Do the authors use any tools to help them analyze the performance? I suggest the authors use model-specific tools (e.g., tools based on OMPT and PMPI interfaces for OpenMP and MPI) to learn the behaviors inside the models.



Review #200E
===========================================================================

Paper summary
-------------
This paper proposed Task Bench, a parameterized benchmark, for evaluating the performance of parallel and distributed programming systems. A new metric minimum effective task granularity (METG) is introduced to characterize the contribution of runtime overheads to application performance.

List of main strengths of the paper
-----------------------------------
* It is an interesting work with a comprehensive comparison for 15 programming systems.
* Task Bench core library includes identical implementations of the kernels and is fully validated with a quite low overhead. 
* Many experiments and analysis are evaluated.

List of major weaknesses of the paper
-------------------------------------
* This paper is a bit hard to follow. The writing needs to be polished. 
* The compute- and memory-bound kernels used to simulate application problems need to have more details described, to make it more convincing and representable. 
* Some experimental results to justify that METG "50%" is the optimal or more acceptable choice.
* Since memory-bound algorithms are critical in real applications, more experiments on them are needed. And only one compute-bound kernel has been used, and it seems simple and hard to represent real applications.

Overall merit
-------------
C. Weak paper, though I will not fight strongly against it

Reviewer expertise
------------------
Z. I am not an expert; my evaluation is that of an informed outsider

Short (2-3 sentence) summary of your review explaining your overall merit score
-------------------------------------------------------------------------------
This is an interesting work. My main concern is that only two simple kernels used for all experiments, mostly only one the compute-bound kernel being used. It is not representative for me. Besides, the kernels are lack of description.

Novelty
-------
2. Incremental improvement

Potential for impact
--------------------
3. Moderate Impact: Will influence other efforts

Writing quality
---------------
2. Needs improvement

Questions for authors’ response
---------------------------------
* How to keep the core library the same for CPU programming systems and GPU programming systems, like CUDA? Also for implicitly parallel systems and explicitly parallel systems?
* P. 7 Line 762: I don't see "Most systems hit 100% of peak, unlike the compute-bound case." Any explanation?
* Why Tensorflow is missing from Fig. 8?
* P. 8 Line 839-844: Could you explain these sentences? How to get this summary for large-scale data analytics workloads and scientific simulations?

Comments to authors
-------------------
* No supplemental material can be seen. This paper needs to be self-complete without the supplemental material.
* More details of "Implementation" section is needed.
* What does "Stencil, 1 node" mean? The stencil computation on one grid node or other meaning?
* Load balancing results should be included in the paper if needed to be shown.
* Simulating "varying problem size" by "varying the number of iterations" is not convincing. The program behavior could be quite different.
* P.6 Line 641-642: the measured FLOP/s 1.26*10^12 is larger than the reported number 1.2*10^12. More accurate machine peak performance can be computed.
* I think conventionally we draw a figure with problem size increasing from left to right on x-axis, not reversely.
