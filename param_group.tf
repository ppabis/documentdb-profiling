resource "aws_docdb_cluster_parameter_group" "profiler-params" {
  family      = "docdb4.0"
  name        = "param-group-profiler"
  description = "Parameter group with TLS and profiling enabled"

  parameter {
    name  = "tls"
    value = "enabled"
  }

  parameter {
    name  = "profiler"
    value = "enabled"
  }

  # Log all of the slow queries
  parameter {
    name  = "profiler_sampling_rate"
    value = "1.0"
  }

  # This is the lowest possible
  parameter {
    name  = "profiler_threshold_ms"
    value = "50"
  }
}
