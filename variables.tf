variable "namespace" {
  description = "Namespace relative to the provider namespace. Vault Enterprise only"
  type        = string
  default     = null

  validation {
    condition = var.namespace != null ? (
      !startswith(var.namespace, "/") && !endswith(var.namespace, "/")
    ) : true
    error_message = "Namespace cannot begin or end with \"\""
  }
}

variable "path" {
  description = "Path to mount the JWT Auth backend"
  type        = string
  default     = "jwt"
}

variable "auth_description" {
  description = "Description of the JWT Auth Backend"
  type        = string
  default     = "Terraform Cloud"
}

variable "auth_token_issuer" {
  description = "Token issuer of JWT token"
  type        = string
  default     = "https://app.terraform.io"

  validation {
    condition     = startswith(var.auth_token_issuer, "https://") && !endswith(var.auth_token_issuer, "/")
    error_message = "Token issuer URI should start with https:// and not end with a slash"
  }
}

variable "auth_tune" {
  description = "Auth mount tune settings"
  type = object({
    default_lease_ttl            = optional(string)
    max_lease_ttl                = optional(string)
    audit_non_hmac_response_keys = optional(list(string))
    audit_non_hmac_request_keys  = optional(list(string))
    listing_visibility           = optional(string)
    passthrough_request_headers  = optional(list(string))
    allowed_response_headers     = optional(list(string))
    token_type                   = optional(string)
  })
  default = null
}

variable "bound_audiences" {
  description = "List of audiences to be allowed for JWT auth roles"
  type        = list(string)
  default     = ["tfc.workload.identity"]
}

variable "workspaces" {
  description = "List of workspaces to provide access to. Use * for wildcard. If wildcard is used, identity management cannot be enabled"
  type        = map(map(list(string))) # First Key is Organisation name, second Key is Project
}

variable "role_name_format" {
  description = "Format string to generate role namess. The first parameter is the organization, and the second is the workspace name"
  type        = string
  default     = "%[1]s-%[2]s-%[3]s"
}

variable "claim_mappings" {
  description = "Mapping of claims to metadata"
  type        = map(string)
  default = {
    terraform_run_phase         = "terraform_run_phase"
    terraform_workspace_id      = "terraform_workspace_id"
    terraform_organization_id   = "terraform_organization_id"
    terraform_organization_name = "terraform_organization_name"
    terraform_run_id            = "terraform_run_id"
    terraform_full_workspace    = "terraform_full_workspace"
  }
}

variable "token_policies" {
  description = "Default token policies to apply to all roles"
  type        = list(string)
  default     = []
}

variable "token_ttl" {
  description = "The incremental lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time."
  type        = number
  default     = 600
}

variable "token_max_ttl" {
  description = "The maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time."
  type        = number
  default     = 600
}

variable "token_explicit_max_ttl" {
  description = "If set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if token_ttl and token_max_ttl would otherwise allow a renewal."
  type        = number
  default     = 600
}

variable "enable_identity_management" {
  description = "Enable Identity Entity management. This only works if workspace names contains no wildcard"
  type        = bool
  default     = true
}

variable "identity_name_format" {
  description = "Identity name format string. The first parameter is the organization, and the second is the workspace name"
  type        = string
  default     = "tfc-%[1]s-%[2]s-%[3]s"
}

variable "tfc_project_support_match" {
  description = "The key to use for Terraform Cloud Project matching in the subject key. This is to work around the module not support projects. You should set this to 'Default Project' or '*'"
  type        = string
  default     = "*"
}

variable "tfc_default_project" {
  description = "Name of TFC Default Project"
  type        = string
  default     = "Default Project"
}

variable "enable_global_identity" {
  description = "Enable Identity Entity management globally. This creates a single entity for all workspaces per organization"
  type        = bool
  default     = false

  validation {
    condition     = var.enable_global_identity != var.enable_identity_management
    error_message = "Global Identity management can only be enabled if Identity management is disabled"
  }
}
