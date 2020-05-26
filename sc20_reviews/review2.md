# Detailed Comments for Authors

The paper covers work on developing a benchmark that enables comparison of a number of different programming models. In addition they develop a metric, minimum effective task granularity (METG) that tries to capture the amount of useful work and overhead of the programming model.
The paper is well written and details the benchmark implementation and covers a number of results. There is a comment about adding load balancing results in the final paper but it might have been nice to see those included in an Appendix so we can review.
The paper includes a number of different results but what would make the paper stronger is a little bit more discussion on the "winners" and "losers" of the experiments and why that is the case. What features about the programming model make it that way. There is some discussion about this for the bad performers but having more included for each graph would make the paper stronger.
The METG metric is introduced as a way to compare systems but validating this with previous results would make this really strong. For example, in the related work section there are references sited which compare the performance of mini-apps for different programming systems. They only compare a few compared to Task Bench but given those few can you make some comparison validating the METG metric to the references papers performance comparison which probably involves wall clock time? For example NPBs has an FFT implementation and so does Task Bench. How can METG be used to replace NPBs evaluation based on wall clock time?

# Comments for Revision

Please add a little bit more discussion on the results of the Task Bench figures for the different programming models and how the METG metric validates against traditional wall clock performance metric.
