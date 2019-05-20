# Detailed Comments for Authors

This paper introduces TaskBench, a parameterized benchmark
infrastructure for evaluating performance of different parallel
systems.

The authors introduce a novel metric (METG) for characterizing task
granularity of parallel programs.

The authors have implemented TaskBench on 13 different parallel and
distributed systems and evaluated the performance

The paper is very well written, with ideas, implementation and results
clearly presented.

The evaluation section is comprehensive, and the result discussion is
detailed.


# Comments for Revision

There are several interesting parallel programming systems for which
you did not implement TaskBench. UPC, OpenSHMEM, Hadoop, OCR,
Habanero, to name a few. I completely understand that it is not
realistic to expect you to cover all the models out there, but it
would be useful and interesting to see a couple of paragraphs of a
discussion of these models, how would TaskBench map onto them, and any
interesting issues one might expect when porting TaskBench to them.

Please include a legend for Figures 3 and 4. We have no idea what
those lines represent.
