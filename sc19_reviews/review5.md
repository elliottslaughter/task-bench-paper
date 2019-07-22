# Detailed Comments for Authors

This paper introduces a new benchmark (Task Bench) and a new metric
"minimum effective task granularity" METG. The metric is studied over
a large number of programming models including MPI, Chapel, Charm++,
OmpSs, OpenMP, PaRSEC, Realm, Regent, Spark, StarPU, Swift/T,
TensorFlow and X10.

Strong points:

  - a novel metric "minimum effective task granularity" METG to study
    the baseline runtime of programming systems is introduced

  - the evaluation is done with a large number of programming models:
    MPI, Chapel, Charm++, OmpSs, OpenMP, PaRSEC, Realm, Regent, Spark,
    StarPU, Swift/T, TensorFlow and X10


Weak points:

  - A lot of space is needed to briefly present the different
    programming models. Given the need to be more verbose at other
    places I consider this a waste of space.

  - This paper introduces a new metric, a new benchmark covering
    aspects like task granularity, load imbalance, asynchronous
    communication, task dependencies and the related patterns and many
    different programming models. As a consequence of tthis missing
    focus it lacks detail in many of the covered aspects. I also argue
    that the space needed to compare to mini-apps in the related works
    section is wasted. IMHO mini-apps should be mentioned in the
    motivation section only.


Other comments to the authors:

When you say: "comprehensive and comparative performance evaluations
remain difficult to find. " Please specify in more detail. There are
many publications on this topic in general. Please specify exactly
which topic/focus you consider hard to find.

You state: "mini-apps can provide insight without the expense of
developing a production code. " IMHO this is the wrong approach
timmini-apps. Real applications are not written for performance
insight. Mini-appsk are but they should represent real appsk without
thier portability and other problems/limitations (license, etc.)

The "intuitive" definition of METG: "Intuitively, METG(50%) is the
smallest executable task granularity that maintains at least 50%
efficiency, meaning that the application achieves at least 50% of peak
performance (e.g., FLOPS or memory bandwidth) on a given
machine. METG" is neither a definition nor intuitive. Only for a
limited number of applications the "peak performance" is well defined
or within the reach of 50%. If you want to refer to the best
performance that is achieved by a specific application you should make
that clear.

I consider the legend and explanation of both Fig. 3 and 4 inadequate.

You mention "The output of every task in Task Bench is unique, and all
inputs are verified." How do you achieve that? IMHO this is an
important point.


# Comments for Revision

Please define "peak performance" in your definition of METG more
precisely. Make sure that it is applicable to applications beyond
obviously compute or memory bound kernels.
