PLDI 2020 Paper #262 Reviews and Comments
===========================================================================
Paper #262 Task Bench: A Parameterized Benchmark for Evaluating Parallel
Runtime Performance


Review #262A
===========================================================================

Overall merit
-------------
C. I would not accept this paper but will not argue strongly against
   accepting it.

Reviewer expertise
------------------
X. Expert

Paper summary
-------------
The paper proposes an approach to generate micro-benchmarks to test numerous programming systems. Task Bench provides an API  to specify task graphs where each node is a task and edges indicate dependencies. It relieves the programmer from writing the same micro-benchmark with each programming system.  Further, the paper proposes minimum effective task granularity (METG) for a particular efficiency metric. The paper evaluates 15 systems with Task Bench and identifies task granularities.

Comments for author
-------------------
Understanding the performance of large systems is a challenging issue. Developing appropriate micro-benchmarks to identify these issues is an important task. Specifically, it is difficult to say when an application is suitable for a particular framework. 

## Strengths

1.  I think the TaskBench has a good goal of evaluating multiple programming systems with a common framework.

2. Evaluation with 15 systems


## Weakness

1.  Limited novelty -- task graph API and testing numerous systems with a single API based test harness is not novel (see below)

2. I don't think METG metric is of much use especially as it is dependent on the efficiency metric.

## Lack of Novel Insight

1. The experiments do not convey novel insight about the tested frameworks and their differences. I do not  consider having a different minimum effective task granularity (METG) for each framework as a new discovery. Moreover, users of a given framework usually know (either from test cases or framework documentation) what task size should be chosen to amortize the cost of runtime overheads associated with task creation, communication, etc.

2.  Even for a single parallel framework METG changes depending on the system’s configuration, the parameters of the Task Bench program, and the efficiency metric.  How can this metric be used to optimize their programs that may have more varied task graphs by HPC developers?

## Suggestions for Improvement 

1. Due to the multitude of the tested frameworks, the graphs in Figures 6-13 have are hard to read. Moreover, it’s not clear what’s the takeaway point of using all these different frameworks. Further, missing data points with Spark, TensorFlow systems make it even difficult to parse.

2.  Authors mention in the conclusion “Task Bench has proven effective in finding performance issues and has lead led to substantial improvements in several of the systems we study”. However, I do not see the rest of the paper explaining these issues and how Task Bench has helped  them in identifying them. Perhaps, rewriting the evaluation to pinpoint such experiments and use cases will make the paper more interesting.

3.  In my opinion, this is not a PLDI paper without the above analysis. In its current state,  It is more suitable for a workload characterization venue.



Review #262B
===========================================================================

Overall merit
-------------
B. I support accepting this paper but will not champion it.

Reviewer expertise
------------------
Y. Knowledgeable

Paper summary
-------------
The paper describes a system for running parameterised benchmarks on a very wide
variety of parallel runtime systems. A parameterised task graph can be built up
of memory- and compute-bound tasks and then run on any parallel runtime system
for which Task Bench has a backend.

This allows the parallel runtime systems to be compared for the compute power
achieved in practice, and most interestingly for the efficiency for different
task granularities to be evaluated.

Comments for author
-------------------
I would have thought going into this paper than the task graphs created by this
system would be biased towards one particular sort of parallel runtime system,
perhaps not even tractable to be implemented on some, but the extremely wide
range of parallel runtime systems for which backends have been implemented gives
a lot of confidence and is commendable work.

METG seems like a useful metric to me. How much does it depend on the layout of
the cluster though? Surely it depends on the network architecture and the
physical machines, the quality of the links, etc, rather than just the parallel
runtime system? Do some parallel runtime systems work better with different
network architectures than others? Does your particular network architecture
introduce bias?

What publications are using tasks-per-second? I don't see this often
myself and you don't reference when you say it's the usual metric. It seems
meaningless to me - depends highly on what is in the task.

How do these parameterised benchmarks correspond to applications? When I set a
height, width, dependence pattern, kernel, how does that correspond to a given
application's workload? Can you give example parameters that are similar to
production applications that you have studied? How do I choose parameters for my
purposes? I think there are two computational nodes - compute bound and memory
bound. It all seems very numerical. Does it also fit symbol computation?

Can you comment directly on irregular parallelism? The sample task graphs look
extremely regular to me. Can the shape of dependencies depend on runtime data?

How idiomatic are the backends? The MPI example in Listing 2 seems reasonable,
as this model explicitly creates tasks. What does an OpenMP backend look like? I
can't imagine a function taking a Graph and implementing it using OpenMP in the
same way. I'd like to see more than one example of the backends, as how you
manage to implement on so many of them is the most interesting part of the paper
to me.



Review #262C
===========================================================================

Overall merit
-------------
A. I will champion accepting this paper.

Reviewer expertise
------------------
X. Expert

Paper summary
-------------
This paper introduces a system, Task Bench, for uniformly generating
parallel scheduling benchmarks across a wide range of systems.  The
generated benchmarks are parameterized across several dimensions,
including compute, memory usage, dependency topology and message size.
The framework is used to perform a comprehensive evaluation of 15
widely known parallelism frameworks.

Comments for author
-------------------
I've been waiting for this paper for years.  Benchmarking of parallel
runtime systems has been ad-hoc, and very limited in its ability to
draw conclusions across different implementations (which employ
different APIs, programming languages, etc).

This is unabashedly an empirical study, and it's good science.  The
paper presents both valuable empirical results in their own right and
a new tool. One might argue about *technical* novelty.  But one strong
novel contribution is that the tool is the first to enable an
asymptotic decrease in the amount of work to benchmark different
parallelism systems (O(m+n) as opposed to O(mn) implementations, as
the author point out), another is the definition and strong argument
for the METG metric.

I believe this paper can herald a major improvement to the state of
the art for benchmarking runtime task schedulers.  I think it could
have an impact like synchrobench on the field of lock-free data
structures, resulting in better and more comparible results in future
papers.

If you're going to use one number, METG is a good metric.  METG nicely
corresponds to the guidelines that runtime system authors give to
their users, e.g.. "make sure tasks are about 10K cycles". The authors
make excellent arguments against benchmarking using empty tasks, which
is effectively what task microbenchmarks like "parallel fibonnacci"
do.

With 15 systems, the per-system implementation descriptions are
necessarily brief.  One particular thing that confused me when reading
these descriptions was the question of task graph representation, and
specifically when and where such representations are allocated.  Some
systems require construction of explicit task graph data structures,
i.e. a dependency would be represented in advance by a piece of data
somewhere in memory.  For example, the MPI code in listing 2
constructs a representation of task dependencies only locally within a
task (and on the stack!).  Another system may need to explicitly
construct tasks and dependencies (vertices and edges) before the task
is scheduled.

If an explicit task graph API was used for in an implementation, is it
allocated only per *time step* (i.e. in a number of small batches
proportional to `g.height`)?  That is, is the task graph "streamed"?
Or is the entire task graph for the experiment allocated in advance
and then submitted for exeuction?
  (I believe lines 1007,1008 *somewhat* address this...)

Re: table 5: "git subgraph branch" is not a version.  It could mean
something quite different after publication.  Better to include the
hash.

I don't think the units for "problem size" were defined.  I.e. in one
of the graphs, what does a "2^2" problem size actually *mean*?
Actually, the exact details of task graph construction at a given
problem size were not clear.  Table 2 indicates that stencils are 1D
with 3 dependencies per task, but how is height vs width changed as
problem size is varied?

Please define "MPI p2p", especially as it is the winner in several
experiments.

Re: load imbalance: I don't think having each task take a uniform
random duration is imbalanced enough.  The law of large numbers should
ensure that load on a given node averages out.  More skewed
distributions of task duration would test which parallel systems can
load balance *between* nodes.  However, it's reasonable to push this
off to future work, as mentioned on line 1089.



Review #262D
===========================================================================

Overall merit
-------------
B. I support accepting this paper but will not champion it.

Reviewer expertise
------------------
Y. Knowledgeable

Paper summary
-------------
This paper presents TaskBench: a high-level, task-graph based language for benchmarking large-scale parallel and distributed systems (e.g. HPC clusters) and their corresponding programming frameworks (e.g. MPI). To support TaskBench, the host framework implements a small API; then TaskBench can evaluate the performance on synthetic tasks. A new metric, METG, is reported that directly relates to pragmatic scaling properties. The system is rigorously evaluated over many frameworks and their differences properties (load balancing, asynchronous memory transfers, etc) are exposed through benchmarking.

Comments for author
-------------------
## Strengths:

+ TaskBench is a useful and timely tool for evaluating and quantitatively comparing the crowded area of parallel/distributed programming frameworks. 

+ The METG metric is pragmatic and intuitive; this will surely be useful as a guide for developers writing code for such systems.

+ While the paper only briefly mentions this contribution: this system is able to find performance bugs in systems.

## Weaknesses:

- The main contribution is a thorough characterization, but concrete takeaways are thin.

- The evaluation is limited in scope and interesting parallel idioms are not considered: transactions, fusions, etc.

This paper is an interesting read in many dimensions: the domain is clear; the empirical evaluation is massive; the reported metrics are intuitive. My favorite thing about the paper is the clear catalog of modern parallel/distributed programming frameworks (section 3). It's nice to see how the evaluation plays out on each of them, where changes (e.g. load imbalance) highlight the strengths (or weaknesses) of the different frameworks.

That said, I was hoping for a few larger takeaway contributions from this work. Nothing particularly surprising stood out to me from the empirical study, e.g. task stealing frameworks handle load imbalance better than others. It would make the paper much stronger to use the characterization to inform some sort of tool, e.g. if taskBench came along with a compiler that could compile programs to one of the many backends based on a performance model derived from the characterization. 

Another comment I have is that there are a lot of backends shown in the graphs and discussed. This is great for breadth, but in the end, it would be nice if they could all be summarized somehow. For example, one of the most used frameworks (OpenMP) didn't get discussed in the text nearly at all. If these frameworks were to be classified into a more coarse grain (e.g. using certain performance profiles), then it would be easier to see similarities and differences between frameworks.

I think the paper should be a little more upfront about the limitations w.r.t. different parallel programming idioms that are not benchmarked in this scheme. For example, MPI likely has very efficient broadcasting capabilities. OpenMP has really nice support for reductions at the end of a parallel loop. It isn't completely fair to these systems to present the taskBench performance as telling the whole story.

A minor point is that the introduction isn't clear that taskBench targets *software* stacks. While reading the introduction, I initially thought the paper would be related to classic hardware benchmark suites like SPEC, SHOC, and Parboil. 

As is, the paper would likely be a huge hit at a characterization conference like IISWC. I think for PLDI, it would be nice to see an application (e.g. compiler) of the characterization. That said, this is an interesting paper with an impressive empirical study.
