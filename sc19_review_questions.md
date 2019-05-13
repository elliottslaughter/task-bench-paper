Review 1

1. The last paragraph in Section 3 describes the memory-bound kernel as one making array traversals. It says that "the duration ... can be configured by setting the number of iterations ... we use this ability to simulate ... program sizes." I'd think that the program size is simulated by the array size, not the number of iterations. Please specify.

2. In general, the paper should be more clear about the specifics of the design. Can you specify Task Bench in pseudo code? For precision and completeness, the paper can show a list of all Task Bench parameters and then the pseudo code to show exactly how they are used, e.g. what input parameters are used to determine the array size?

Review 2

1. There are several interesting parallel programming systems for which you did not implement TaskBench. UPC, OpenSHMEM, Hadoop, OCR, Habanero, to name a few. I completely understand that it is not realistic to expect you to cover all the models out there, but it would be useful and interesting to see a couple of paragraphs of a discussion of these models, how would TaskBench map onto them, and any interesting issues one might expect when porting TaskBench to them.

2. Please include a legend for Figures 3 and 4. We have no idea what those lines represent.

Review 3

1. The metric METG, though interesting, does not capture the changes in the underlying hardware and seems to assume uniform support. Also, since it is measured as a unit of time, it is unclear how this information can be utilized by an application programmer. Some issues with METG metric are: 1) it cannot be calculated without the actual wall time data for the runs, 2) it is system dependent and 3) even if ideal task granularity is known it is impossible to scope out exact groups of LOC that will satisfy the METG metric as times may change depending on other system conditions.

2. The rest of the paper presents different data-points but the message is not clear. The focus clearly shifts from Task Bench to METG metric. It would have been interesting to see the validation of the Task Bench approach by comparing the performance envelopes observed through Task Bench with actual runs.

3. The paper presents a lot of data without conclusive analysis. The utility of the TaskBench to explore the performance envelopes of parallel and distributed programming systems is missing.

Review 4

1. What would be useful to see is an analysis with aBSP style model. While asynchronous task graphs are relevant in many domains, there are many codes that require bulk-synchronization between phases of computation

2. In addition, while the promise of a parameterizable benchmark lies in the reduction of programming effort relative to developing proxy-applications for each programming system, the authors do not devote any attention to this aspect. Some way to quantify the improved productivity would have helped to make the case for why Task Bench is useful.

3. The performance results presented are a small sampling of the combinatorial explosion of parameter values, but they do not yield generalizable insight.

4. - In Figure 1, it is not clear what is meant by "problem size". Is this the number of tasks? Units on the x-axis would help this figure.

5. It is not clear how to interpret Figures 3 and 4. A legend might help here. The graphs are so dense that it may help readability to not include all of the data.

6. How are dependencies between tasks defined for tasks that are co-scheduled on the same processor? Do all dependencies result in messages or can shared memory be used (depending on the programming system under study)

7. I would like to see more discussion of the architecture of Task Bench itself. How much of the benchmark needs to be rewritten for each programming system?

8. Can Task Bench be extended to use accelerators (e.g., CUDA for multi-GPU nodes)

9. A lot of space in Section 4 is devoted to describing the parallel programming systems. Would it be easier and more concise to simply highlight the relevant characteristics that make each one unique or interesting?

10. I would like to see how Task Bench can handle accelerator-based programming models, such as MPI+X. Such hierarchical models are common for HPC applications, but this paper does not address them.

Review 5

1. A lot of space is needed to briefly present the different programming models. Given the need to be more verbose at other places I consider this a waste of space

2. This paper introduces a new metric, a new benchmark covering aspects like task granularity, load imbalance, asynchronous communication, task dependencies and the related patterns and many different programming models. As a consequence of tthis missing focus it lacks detail in many of the covered aspects. I also argue that the space needed to compare to mini-apps in the related works section is wasted. IMHO mini-apps should be mentioned in the motivation section only. 

3. When you say: "comprehensive and comparative performance evaluations remain difficult to find. " Please specify in more detail. There are many publications on this topic in general. Please specify exactly which topic/focus you consider hard to find.

4. You state: "mini-apps can provide insight without the expense of developing a production code. " IMHO this is the wrong approach timmini-apps. Real applications are not written for performance insight. Mini-appsk are but they should represent real appsk without thier portability and other problems/limitations (license, etc.)

5. The "intuitive" definition of METG: "Intuitively, METG(50%) is the smallest executable task granularity that maintains at least 50% efficiency, meaning that the application achieves at least 50% of peak performance (e.g., FLOPS or memory bandwidth) on a given machine. METG" is neither a definition nor intuitive. Only for a limited number of applications the "peak performance" is well defined or within the reach of 50%. If you want to refer to the best performance that is achieved by a specific application you should make that clear.

6. I consider the legend and explanation of both Fig. 3 and 4 inadequate

7. You mention "The output of every task in Task Bench is unique, and all inputs are verified." How do you achieve that? IMHO this is an important point.

8. Please define "peak performance" in your definition of METG more precisely. Make sure that it is applicable to applications beyond obviously compute or memory bound kernels.




