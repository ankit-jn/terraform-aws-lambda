## Lambda Function
resource aws_lambda_function "this" {
    
    function_name = var.name
    role = var.create_role ? module.lambda_role.service_linked_roles[local.lambda_role_name].arn : var.role_arn

    description = var.description
    
    architectures = [var.architecture]
    runtime = var.runtime
    package_type = var.package_type

    filename = var.file_name

    image_uri = var.image_uri

    s3_bucket = var.s3_bucket
    s3_key = var.s3_key
    s3_object_version = var.s3_object_version

    source_code_hash = var.image_uri != null ? null : (
                                    var.file_name != null ? filebase64sha256(var.file_name) : filebase64sha256(var.s3_key))

    handler = var.handler
    memory_size = var.memory_size
    timeout = var.timeout
    reserved_concurrent_executions = var.reserved_concurrent_executions
    kms_key_arn = var.kms_key_arn

    publish = var.publish

    ephemeral_storage {
       size =  var.ephemeral_storage
    }

    dynamic "environment" {
        for_each = length(keys(var.environment_variables)) > 0 ? [1] : []
        
        content {
          variables = var.environment_variables
        }
    }

    dynamic "dead_letter_config" {
        for_each = var.dead_letter_target_arn != null ? [1] : []

        content {
            target_arn = var.dead_letter_target_arn
        }
    }

    dynamic "vpc_config" {
        for_each = (length(var.subnet_ids) > 0 && length(var.sg_ids) > 0) ? [1] : []

        content {
            subnet_ids = var.subnet_ids
            security_group_ids = var.sg_ids
        }
    }

    dynamic "snap_start" {
        for_each = var.enable_snap_start ? [1] : []

        content {
            apply_on = "PublishedVersions"
        }
    }

    dynamic "tracing_config" {
        for_each = var.tracing_mode != null ? [1] : []

        content {
            mode = var.tracing_mode
        }
    }

    tags = merge({"Name" = var.name}, var.tags)
}

## Lambda Function Aliases
resource aws_lambda_alias "this" {
    for_each = { for alias in aliases: alias.name => alias }

    name = each.key
    description = lookup(each.value, "description", null)
    function_name = aws_lambda_function.this.arn
    function_version = lookup(each.value, "function_version", "$LATEST")

    dynammic "routing_config" {
        for_each = (try(length(keys(each.value.additional_version_weights)), 0) > 0) ? [1] : []
        content {
            additional_version_weights = each.value.additional_version_weights
        }
    }
}

## Lambda Execution IAM Role
module "lambda_role" {
    source = "git::https://github.com/arjstack/terraform-aws-iam.git?ref=v1.0.0"
    
    count = var.create_role ? 1 : 0

    policies = local.policies_to_create

    service_linked_roles = {
                            name = local.lambda_role_name
                            description = "IAM Role for Lambda Function"
                            service_names = [
                                "lambda.amazonaws.com"
                            ] 
                            policy_list = var.policies
                        }

    role_default_tags = merge({"Name" = format("%s-role", var.name)}, {"Lambda" = var.name}, var.tags)
    policy_default_tags = merge({"Name" = format("%s-role-policy", var.name)}, {"Lambda" = var.name}, var.tags)
}
