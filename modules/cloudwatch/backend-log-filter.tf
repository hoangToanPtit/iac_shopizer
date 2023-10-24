resource "aws_cloudwatch_log_metric_filter" "http_request_be" {
  name           = "http_request"
  pattern        = "\"http-nio\""
  log_group_name = "backend.log"

  metric_transformation {
    name      = "Backend_Metric"
    namespace = "http_request_be"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_request_error" {
  name           = "http_request_error_be"
  pattern        = "\"ERROR\" \"http-nio\""
  log_group_name = "backend.log"

  metric_transformation {
    name      = "Backend_Metric"
    namespace = "http_request_error_be"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "number_exception" {
  name           = "number_exception_be"
  pattern        = "exception"
  log_group_name = "backend.log"

  metric_transformation {
    name      = "Backend_Metric"
    namespace = "number_exception_be"
    value     = "1"
  }
}
