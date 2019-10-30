void execute_task_graph(Graph g) {
  char *output = (char *)malloc(g.output_bytes_per_task);
  char *scratch = (char *)malloc(g.scratch_bytes_per_task);
  char **inputs = (char **)malloc(g.max_dependencies_per_task * sizeof(char *));
  char *input_bytes = (size_t *)malloc(g.max_dependencies_per_task * sizeof(size_t));
  long num_inputs;

  long rank;
  std::vector<long> rank_by_point; // maps points to ranks
  std::vector<MPI_Request> requests;

  // initialize data structures...

  for (long t = 0; t < g.height; ++t) {
    if (g.contains_point(t, rank)) {
      num_inputs = 0;
      requests.clear();

      for (long dep : g.dependencies(t, rank)) {
        MPI_Request req;
        MPI_Irecv(
          inputs[num_inputs], input_bytes[num_inputs], MPI_BYTE,
          rank_by_point[dep], 0, MPI_COMM_WORLD, req);
        requests.push_back(req);
        num_inputs++;
      }

      for (long dep : g.reverse_dependencies(t, rank)) {
        MPI_Request req;
        MPI_Isend(
          output, g.output_bytes_per_task, MPI_BYTE,
          rank_by_point[dep], 0, MPI_COMM_WORLD, req);
        requests.push_back(req);
      }

      MPI_Waitall(requests.size(), requests.data(), MPI_STATUSES_IGNORE);

      g.execute_point(
        t, rank,
        output, g.output_bytes_per_task,
        inputs, input_bytes, num_inputs,
        scratch, g.scratch_bytes_per_task);
    }
  }
}
