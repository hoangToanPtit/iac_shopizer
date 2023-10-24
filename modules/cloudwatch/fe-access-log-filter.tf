resource "aws_cloudwatch_log_metric_filter" "http_200_fe" {
  name           = "Http_200_fe"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code=2*, size]"
  log_group_name = "fe-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_200_fe"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_5xx_fe" {
  name           = "Http_5xx_fe"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code=5*, size]"
  log_group_name = "fe-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "Http_5xx_fe"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_4xx_fe" {
  name           = "Http_error_4xx_fe"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code=4*, size]"
  log_group_name = "fe-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_4xx_fe"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_latency_fe" {
  name           = "Http_latency_fe"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code, size]"
  log_group_name = "fe-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_latency_fe"
    value     = "$request_time"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_request_fe" {
  name           = "Http_request_fe"
  pattern        = "[ip, id, user, timestamp, request_time, request=*HTTP*, status_code, size]"
  log_group_name = "fe-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_request_fe"
    value     = "1"
  }
}
