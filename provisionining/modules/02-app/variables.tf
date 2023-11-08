variable "shorty_lambda_exec_policy_arn" {
    description = "ARN of the IAM policy that allows the shorty lambda to execute"
    type        = string
}

variable "bucket_name" {
    description = "Name of the S3 bucket that stores shortened URLs"
    type        = string
}