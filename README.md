# Vault TFC Workload Identity

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 3.7 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_identity_entity.workspaces](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity) | resource |
| [vault_identity_entity_alias.workspaces](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity_alias) | resource |
| [vault_jwt_auth_backend.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.roles](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth_description"></a> [auth\_description](#input\_auth\_description) | Description of the JWT Auth Backend | `string` | `"Terraform Cloud"` | no |
| <a name="input_auth_token_issuer"></a> [auth\_token\_issuer](#input\_auth\_token\_issuer) | Token issuer of JWT token | `string` | `"https://app.terraform.io"` | no |
| <a name="input_auth_tune"></a> [auth\_tune](#input\_auth\_tune) | Auth mount tune settings | <pre>object({<br>    default_lease_ttl            = optional(string)<br>    max_lease_ttl                = optional(string)<br>    audit_non_hmac_response_keys = optional(string)<br>    audit_non_hmac_request_keys  = optional(string)<br>    listing_visibility           = optional(string)<br>    passthrough_request_headers  = optional(string)<br>    allowed_response_headers     = optional(string)<br>    token_type                   = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_bound_audiences"></a> [bound\_audiences](#input\_bound\_audiences) | List of audiences to be allowed for JWT auth roles | `list(string)` | <pre>[<br>  "tfc.workload.identity"<br>]</pre> | no |
| <a name="input_claim_mappings"></a> [claim\_mappings](#input\_claim\_mappings) | Mapping of claims to metadata | `map(string)` | <pre>{<br>  "terraform_full_workspace": "terraform_full_workspace",<br>  "terraform_organization_id": "terraform_organization_id",<br>  "terraform_organization_name": "terraform_organization_name",<br>  "terraform_run_id": "terraform_run_id",<br>  "terraform_run_phase": "terraform_run_phase",<br>  "terraform_workspace_id": "terraform_workspace_id"<br>}</pre> | no |
| <a name="input_enable_identity_management"></a> [enable\_identity\_management](#input\_enable\_identity\_management) | Enable Identity Entity management. This only works if workspace names contains no wildcard | `bool` | `true` | no |
| <a name="input_identity_name_format"></a> [identity\_name\_format](#input\_identity\_name\_format) | Identity name format string. The first parameter is the organization, and the second is the workspace name | `string` | `"tfc-%[1]s-%[2]s"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace relative to the provider namespace. Vault Enterprise only | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | Path to mount the JWT Auth backend | `string` | `"jwt"` | no |
| <a name="input_role_name_format"></a> [role\_name\_format](#input\_role\_name\_format) | Format string to generate role namess. The first parameter is the organization, and the second is the workspace name | `string` | `"%[1]s-%[2]s"` | no |
| <a name="input_tfc_project_support_match"></a> [tfc\_project\_support\_match](#input\_tfc\_project\_support\_match) | The key to use for Terraform Cloud Project matching in the subject key. This is to work around the module not support projects. You should set this to 'Default Project' or '*' | `string` | `"*"` | no |
| <a name="input_token_explicit_max_ttl"></a> [token\_explicit\_max\_ttl](#input\_token\_explicit\_max\_ttl) | If set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if token\_ttl and token\_max\_ttl would otherwise allow a renewal. | `number` | `600` | no |
| <a name="input_token_max_ttl"></a> [token\_max\_ttl](#input\_token\_max\_ttl) | The maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time. | `number` | `600` | no |
| <a name="input_token_policies"></a> [token\_policies](#input\_token\_policies) | Default token policies to apply to all roles | `list(string)` | `[]` | no |
| <a name="input_token_ttl"></a> [token\_ttl](#input\_token\_ttl) | The incremental lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time. | `number` | `600` | no |
| <a name="input_user_claim"></a> [user\_claim](#input\_user\_claim) | Claim to be used as the Identity Entity user | `string` | `"terraform_full_workspace"` | no |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | List of workspaces to provide access to. Use * for wildcard. If wildcard is used, identity management cannot be enabled | `map(list(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_mount_accessor"></a> [auth\_mount\_accessor](#output\_auth\_mount\_accessor) | Auth mount accessor |
| <a name="output_workspaces"></a> [workspaces](#output\_workspaces) | Workspace information |
<!-- END_TF_DOCS -->
