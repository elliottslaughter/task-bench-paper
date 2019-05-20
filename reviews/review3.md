# Detailed Comments for Authors

The paper discusses Task Bench which is a parameterized benchmark
designed to explore the performance envelopes of parallel and
distributed programming systems under a variety of application
scenarios. Task Bench allows for the applications to be modeled as a
set of tasks, or coarse-grain units of work, with dependencies between
tasks representing the communication and synchronization required for
distributed execution. This takes a very simplistic view of
application and programming systems. Contributions of this paper are
the METG metric and Task Bench.

The metric METG, though interesting, does not capture the changes in
the underlying hardware and seems to assume uniform support. Also,
since it is measured as a unit of time, it is unclear how this
information can be utilized by an application programmer. Some issues
with METG metric are: 1) it cannot be calculated without the actual
wall time data for the runs, 2) it is system dependent and 3) even if
ideal task granularity is known it is impossible to scope out exact
groups of LOC that will satisfy the METG metric as times may change
depending on other system conditions.

The rest of the paper presents different data-points but the message
is not clear. The focus clearly shifts from Task Bench to METG
metric. It would have been interesting to see the validation of the
Task Bench approach by comparing the performance envelopes observed
through Task Bench with actual runs.


# Comments for Revision

The paper presents a lot of data without conclusive analysis. The
utility of the TaskBench to explore the performance envelopes of
parallel and distributed programming systems is missing.
