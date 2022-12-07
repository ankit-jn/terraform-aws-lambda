locals {
    lambda_role_name = format("%s-role", var.name)
    policies_to_create = [for policy in var.policies: policy if (lookup(policy, "arn", "") == "")  ]
}