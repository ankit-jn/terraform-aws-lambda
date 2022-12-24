## ARJ-Stack: AWS Lambda Function Terraform module

A Terraform module for provision AWS Lambda, a serverless, event-driven compute workload, without provisioning or managing servers.

### Resources
This module features the following components to be provisioned with different combinations:

- Lambda Function [[aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)]
- Lambda Function Alias [[aws_lambda_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias)]
- Lambda Permissions [[aws_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)]
- Lambda Function URL [[aws_lambda_function_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url)]
- Provisioned Concurrency Configuration [[aws_lambda_provisioned_concurrency_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_provisioned_concurrency_config)]
- IAM Role [[aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)]
- IAM Policy [[aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)]
- IAM Role-Policy Attachment [[aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)]

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

### Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-lambda) for effectively utilizing this module.

### Inputs
---

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | The name of the Lambda function. | `string` |  | yes | |
| <a name="description"></a> [description](#input\_description) | Description of what your Lambda Function does. | `string` | `null` | no | |
| <a name="architecture"></a> [architecture](#input\_architecture) | Instruction set architecture for Lambda function. | `string` | `"x86_64"` | no | |
| <a name="runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime. | `string` | `null` | no | |
| <a name="package_type"></a> [package_type](#input\_package\_type) | Lambda deployment package type. | `string` | `"Zip"` | no | |
| <a name="file_name"></a> [file_name](#input\_file\_name) | Path to the function's deployment package within the local filesystem. | `string` | `null` | no | |
| <a name="image_uri"></a> [image_uri](#input\_image\_uri) | ECR image URI containing the function's deployment package. | `string` | `null` | no | |
| <a name="s3_bucket"></a> [s3_bucket](#input\_s3\_bucket) | S3 bucket location containing the function's deployment package. | `string` | `null` | no | |
| <a name="s3_key"></a> [s3_key](#input\_s3\_key) | S3 key of an object containing the function's deployment package. | `string` | `null` | no | |
| <a name="s3_object_version"></a> [s3_object_version](#input\_s3\_object\_version) | Object version containing the function's deployment package. | `string` | `null` | no | |
| <a name="handler"></a> [handler](#input\_handler) | Function entrypoint in your code. | `string` | `null` | no | |
| <a name="memory_size"></a> [memory_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. | `number` | `128` | no | |
| <a name="timeout"></a> [timeout](#input\_timeout) | Amount of time that Lambda Function has to run in seconds. | `number` | `3` | no | |
| <a name="reserved_concurrent_executions"></a> [reserved_concurrent_executions](#input\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions for this lambda function. | `number` | `-1` | no | |
| <a name="kms_key_arn"></a> [kms_key_arn](#input\_kms\_key\_arn) | Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt environment variables. | `string` | `null` | no | |
| <a name="publish"></a> [publish](#input\_publish) | Flag to decide if publish creation/change as new Lambda Function Version. | `bool` | `false` | no | |
| <a name="ephemeral_storage"></a> [ephemeral_storage](#input\_ephemeral\_storage) | The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB. | `number` | `512` | no | |
| <a name="environment_variables"></a> [environment_variables](#input\_environment\_variables) | The map of the environment variables. | `map(string)` | `{}` | no | |
| <a name="efs_arn"></a> [efs_arn](#input\_efs\_arn) | Amazon Resource Name (ARN) of the Amazon EFS Access Point that provides access to the file system. | `string` | `null` | no | |
| <a name="efs_mount_path"></a> [efs_mount_path](#input\_efs\_mount\_path) | Path where the function can access the file system, starting with /mnt/. | `string` | `null` | no | |
| <a name="dead_letter_target_arn"></a> [dead_letter_target_arn](#input\_dead\_letter\_target\_arn) | The ARN of an SNS topic or SQS queue to notify when an invocation fails. | `string` | `null` | no | |
| <a name="subnet_ids"></a> [subnet_ids](#input\_subnet\_ids) | List of subnet IDs associated with the Lambda function. | `list(string)` | `[]` | no | |
| <a name="sg_ids"></a> [sg_ids](#input\_sg\_ids) | List of security group IDs associated with the Lambda function. | `list(string)` | `[]` | no | |
| <a name="tracing_mode"></a> [tracing_mode](#input\_tracing\_mode) |  | `string` | `null` | no | |
| <a name="aliases"></a> [aliases](#alias) | List of Lambda Function Alias configuration Map. | `any` | `[]` | no | |
| <a name="lambda_function_provisioned_concurrency"></a> [lambda_function_provisioned_concurrency](#lambda\_function\_provisioned\_concurrency) | Provisioned Concurrency Configuration for Lambda Function versions. | list(map(string)) | `[]` | no | |
| <a name="tags"></a> [tags](#input\_tags) | Map of default tags to assign to Lambda. | `map(string)` | `{}` | no | |

#### permissions

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="role_arn"></a> [role_arn](#input\_role\_arn) | The Amazon Resource Name (ARN) of the existing function's execution role. | `string` | `null` | no | |
| <a name="create_role"></a> [create_role](#input\_create\_role) | Flag to decide if new IAM Role is required to be provisioned. | `bool` | `true` | no | |
| <a name="policies"></a> [policies](#input\_policies) | List of Policies (to be provisioned) to be attached to IAM Role. | `any` | `[]` | no | |
| <a name="lambda_permissions"></a> [lambda_permissions](#lambda\_permissions) | The list of permissions configuration map, given to external sources to access the Lambda function. | `list(map(string))` | `[]` | no | |

#### Function URL

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="create_lambda_function_url"></a> [create_lambda_function_url](#input\_create\_lambda\_function\_url) | Flag to decide if create Lambda function URL. | `bool` | `false` | no |
| <a name="function_url_qualifier"></a> [function_url_qualifier](#input\_function\_url\_qualifier) | The alias name | `string` | `"$LATEST"` | no |
| <a name="authorization_type"></a> [authorization_type](#input\_authorization\_type) | Type of authentication that the function URL uses. | `string` | "NONE" | no |
| <a name="cors"></a> [cors](#cors) | The cross-origin resource sharing (CORS) settings for the function URL. | `any` | `{}` | no |

### Nested Configuration Maps: 

#### alias

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | The name of the alias. | `string` |  | yes |  |
| <a name="description"></a> [description](#input\_description) | The description of the alias. | `string` | `null` | no |  |
| <a name="function_version"></a> [function_version](#input\_function\_version) | The Lambda function version which this alias is created for. | `string` | `"$LATEST"` | no |  |
| <a name="additional_version_weights"></a> [additional_version_weights](#input\_additional\_version\_weights) | A map of key/value pairs that defines the proportion of events that should be sent to different versions of a lambda function. | `map(string)` | `{}` | no |  |
| <a name="provisioned_concurrent_executions"></a> [provisioned_concurrent_executions](#input\_provisioned\_concurrent\_executions) | Amount of capacity to allocate. | `number` | `0` | no |  |

#### lambda_permissions

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="id"></a> [id](#input\_id) | The unique Name of the permission. | `string` |  | yes |
| <a name="action"></a> [action](#input\_action) | The AWS Lambda action you want to allow in this statement. | `string` | `null` | no |
| <a name="qualifier"></a> [qualifier](#input\_qualifier) | Function version or alias name on which this permission will be applied. | `string` | `null` | no |
| <a name="principal"></a> [principal](#input\_principal) | The principal who is getting this permission. | `string` |  | yes |
| <a name="principal_org_id"></a> [principal_org_id](#input\_principal\_org\_id) | The identifier for your organization in AWS Organizations. | `string` | `null` | no |
| <a name="source_arn"></a> [source_arn](#input\_source\_arn) | The ARN of the specific resource to grant permission to. | `string` | `null` | no |
| <a name="source_account"></a> [source_account](#input\_source\_account) | The AWS account ID (without a hyphen) of the source owner, for allowing cross-account access, or for S3 and SES. | `string` | `null` | no |
| <a name="function_url_auth_type"></a> [function_url_auth_type](#input\_function\_url\_auth\_type) | Lambda Function URLs authentication type. | `string` | `null` | no |
| <a name="event_source_token"></a> [event_source_token](#input\_event\_source\_token) | The Event Source Token to validate. Used with Alexa Skills. | `string` | `null` | no |

#### lambda_function_provisioned_concurrency

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="qualifier"></a> [qualifier](#input\_qualifier) | Function version. | `string` |  | yes |
| <a name="provisioned_concurrent_executions"></a> [provisioned_concurrent_executions](#input\_provisioned\_concurrent\_executions) | Amount of capacity to allocate. | `string` | `0` | yes |

#### cors

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="allow_credentials"></a> [allow_credentials](#input\_allow\_credentials) | Flag to decide if allow cookies or other credentials in requests to the function URL. | `bool` | `false` | no |
| <a name="allow_headers"></a> [allow_headers](#input\_allow\_headers) | The HTTP headers that origins can include in requests to the function URL. | `list(string)` | `null` | no |
| <a name="allow_methods"></a> [allow_methods](#input\_allow\_methods) | The HTTP methods that are allowed when calling the function URL. | `list(string)` | `null` | no |
| <a name="allow_origins"></a> [allow_origins](#input\_allow\_origins) | The origins that can access the function URL. | `list(string)` | `null` | no |
| <a name="expose_headers"></a> [expose_headers](#input\_expose\_headers) | The HTTP headers in your function response that you want to expose to origins that call the function URL. | `list(string)` | `null` | no |
| <a name="max_age"></a> [max_age](#input\_max\_age) | The maximum amount of time, in seconds, that web browsers can cache results of a preflight request. | `number` | `0` | no |

### Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="arn"></a> [arn](#output\_) | `string` | Amazon Resource Name (ARN) identifying the Lambda Function. |
| <a name="qualified_arn"></a> [qualified_arn](#output\_qualified\_arn) | `string` | ARN identifying the Lambda Function Version (if versioning is enabled via publish = true). |
| <a name="invoke_arn"></a> [invoke_arn](#output\_invoke\_arn) | `string` | ARN to be used for invoking Lambda Function from API Gateway. |
| <a name="qualified_invoke_arn"></a> [qualified_invoke_arn](#output\_qualified\_invoke\_arn) | `string` | Qualified ARN (ARN with lambda version number) to be used for invoking Lambda Function from API Gateway. |
| <a name="signing_job_arn"></a> [signing_job_arn](#output\_signing\_job\_arn) | `string` | ARN of the signing job. |
| <a name="signing_profile_version_arn"></a> [signing_profile_version_arn](#output\_signing\_profile\_version\_arn) | `string` | ARN of the signing profile version. |
| <a name="version"></a> [version](#output\_version) | `string` | Latest published version of the Lambda Function. |
| <a name="aliases_arn"></a> [aliases_arn](#output\_aliases\_arn) | `string` | Map of Lambda Function Alias ARNs. |
| <a name="aliases_invoke_arn"></a> [aliases_invoke_arn](#output\_aliases\_invoke\_arn) | `string` | Map of Lambda Function Alias ARNs, used for invoking Lambda Function from API Gateway. |
| <a name="lambda_role_arn"></a> [lambda_role_arn](#output\_lambda\_role\_arn) | `string` | Lambda Execution IAM Role. |
| <a name="function_url"></a> [function_url](#output\_function\_url) | `string` | The HTTP URL endpoint for the function in the format `https://<url_id>.lambda-url.<region>.on.aws`. |

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-lambda/graphs/contributors).