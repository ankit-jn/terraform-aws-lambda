output "arn" {
    description = "Amazon Resource Name (ARN) identifying the Lambda Function."
    value       = aws_lambda_function.this.arn
}

output "qualified_arn" {
    description = "ARN identifying the Lambda Function Version (if versioning is enabled via publish = true)."
    value       = aws_lambda_function.this.qualified_arn
}

output "invoke_arn" {
    description = "ARN to be used for invoking Lambda Function from API Gateway."
    value       = aws_lambda_function.this.invoke_arn
}

output "qualified_invoke_arn" {
    description = "Qualified ARN (ARN with lambda version number) to be used for invoking Lambda Function from API Gateway."
    value       = aws_lambda_function.this.invoke_arn
}

output "signing_job_arn" {
    description = "ARN of the signing job."
    value       = aws_lambda_function.this.signing_job_arn
}

output "signing_profile_version_arn" {
    description = "ARN of the signing profile version."
    value       = aws_lambda_function.this.signing_profile_version_arn
}

output "version" {
    description = "Latest published version of the Lambda Function."
    value       = aws_lambda_function.this.version
}

output "aliases_arn" {
    description = "Map of Lambda Function Alias ARNs."
    value = { for name, alias in aws_lambda_alias.this: name => alias.arn}
}

output "aliases_invoke_arn" {
    description = "Map of Lambda Function Alias ARNs, used for invoking Lambda Function from API Gateway."
    value = { for name, alias in aws_lambda_alias.this: name => alias.invoke_arn}
}

output "lambda_role_arn" {
    description = "Lambda Execution IAM Role."
    value = var.create_role ? module.lambda_role.service_linked_roles[local.lambda_role_name].arn : ""
}

output "function_url" {
    description = "The HTTP URL endpoint for the function in the format `https://<url_id>.lambda-url.<region>.on.aws`."
    value = var.create_lambda_function_url ? aws_lambda_function_url.this.function_url : ""
}