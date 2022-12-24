## Lambda Function
resource aws_lambda_function "this" {
    
    function_name = var.name
    role = var.create_role ? module.lambda_role[0].service_linked_roles[local.lambda_role_name].arn : var.role_arn

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

    layers = length(var.layers) > 0 ? var.layers : null

    ephemeral_storage {
       size =  var.ephemeral_storage
    }

    dynamic "environment" {
        for_each = length(keys(var.environment_variables)) > 0 ? [1] : []
        
        content {
          variables = var.environment_variables
        }
    }

    dynamic "file_system_config" {
        for_each = (var.efs_arn != null && var.efs_arn != "") ? [1] : []

        content {
            arn = var.efs_arn
            local_mount_path = var.efs_mount_path
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

    # dynamic "snap_start" {
    #     for_each = var.enable_snap_start ? [1] : []

    #     content {
    #         apply_on = "PublishedVersions"
    #     }
    # }

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
    for_each = { for alias in var.aliases: alias.name => alias }

    name = each.key
    description = lookup(each.value, "description", null)
    function_name = aws_lambda_function.this.arn ## Either function_name or ARN
    function_version = lookup(each.value, "function_version", "$LATEST")

    dynamic "routing_config" {
        for_each = (try(length(keys(each.value.additional_version_weights)), 0) > 0) ? [1] : []
        content {
            additional_version_weights = each.value.additional_version_weights
        }
    }
}

resource aws_lambda_permission "this" {
    for_each = { for permission in var.lambda_permissions: permission.id => permission }

    statement_id  = each.key
    action        = lookup(each.value, "action", "lambda:InvokeFunction")
    function_name = aws_lambda_function.this.function_name
    qualifier     = lookup(each.value, "qualifier", null)
    principal     = lookup(each.value, "principal")
    principal_org_id = lookup(each.value, "principal_org_id", null)
    source_arn    = lookup(each.value, "source_arn", null)
    source_account = lookup(each.value, "source_account", null)
    function_url_auth_type = (lookup(each.value, "action", "lambda:InvokeFunction") == "lambda:InvokeFunctionUrl") ? lookup(each.value, "function_url_auth_type", null) : null
    event_source_token = lookup(each.value, "event_source_token", null)

    depends_on = [
        aws_lambda_function.this,
        aws_lambda_alias.this
    ]
}

## Provisioned Concurrency Configuration for Lambda Function Version
resource aws_lambda_provisioned_concurrency_config "function" {
    for_each = { for config in var.lambda_function_provisioned_concurrency: config.version => config 
                            if try(config.provisioned_concurrent_executions, 0) > 0 }

    function_name = aws_lambda_function.this.arn
    qualifier     = each.value.qualifier

    provisioned_concurrent_executions = each.value.provisioned_concurrent_executions
}

## Provisioned Concurrency Configuration for Lambda Alias
resource aws_lambda_provisioned_concurrency_config "alias" {
    for_each = { for alias in var.aliases: alias.name => alias 
                            if try(alias.provisioned_concurrent_executions, 0) > 0 }

    function_name = aws_lambda_function.this.arn
    qualifier     = aws_lambda_alias.this[each.key].name

    provisioned_concurrent_executions = each.value.provisioned_concurrent_executions

    depends_on = [
        aws_lambda_alias.this
    ]
}

resource aws_lambda_function_url "this" {
  count = var.create_lambda_function_url ? 1 : 0

  function_name = aws_lambda_function.this.arn ## Name of ARN of the Lambda Function
  qualifier          = var.function_url_qualifier
  
  authorization_type = var.authorization_type

  dynamic "cors" {
    for_each = length(keys(var.cors)) > 0 ? [1] : []

    content {
        allow_credentials = try(var.cors.allow_credentials, false)
        allow_headers     = try(var.cors.allow_headers, null)
        allow_methods     = try(var.cors.allow_methods, null)
        allow_origins     = try(var.cors.allow_origins, null)
        expose_headers    = try(var.cors.expose_headers, null)
        max_age           = try(var.cors.max_age, 0)
    }
  }
}

## Lambda Execution IAM Role
module "lambda_role" {
    source = "git::https://github.com/arjstack/terraform-aws-iam.git?ref=v1.0.0"
    
    count = var.create_role ? 1 : 0

    policies = local.policies_to_create

    service_linked_roles = [{
                            name = local.lambda_role_name
                            description = "IAM Role for Lambda Function"
                            service_names = [
                                "lambda.amazonaws.com"
                            ] 
                            policy_list = var.policies
                        }]

    role_default_tags = merge({"Name" = format("%s-role", var.name)}, {"Lambda" = var.name}, var.tags)
    policy_default_tags = merge({"Name" = format("%s-role-policy", var.name)}, {"Lambda" = var.name}, var.tags)
}