resource "aws_cloudwatch_log_metric_filter" "http_200_adm" {
  name           = "Http_200"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code=2*, size]"
  log_group_name = "adm-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_200_adm"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_5xx_adm" {
  name           = "Http_5xx"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code=5*, size]"
  log_group_name = "adm-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "Http_5xx_adm"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_4xx_adm" {
  name           = "Http_error_4xx"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code=4*, size]"
  log_group_name = "adm-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_4xx_adm"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_latency_adm" {
  name           = "Http_latency"
  pattern        = "[ip, id, user, timestamp, request_time, request, status_code, size]"
  log_group_name = "adm-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_latency_adm"
    value     = "$request_time"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_request_adm" {
  name           = "Http_request"
  pattern        = "[ip, id, user, timestamp, request_time, request=*HTTP*, status_code, size]"
  log_group_name = "adm-access.log"

  metric_transformation {
    name      = "HTTP_Request"
    namespace = "http_request_adm"
    value     = "1"
  }
}
