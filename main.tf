resource "vault_jwt_auth_backend" "this" {
  namespace = var.namespace

  path        = var.path
  type        = "jwt"
  description = var.auth_description


  oidc_discovery_url = var.auth_token_issuer
  bound_issuer       = var.auth_token_issuer

  dynamic "tune" {
    for_each = var.auth_tune != null ? [var.auth_tune] : []

    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      listing_visibility           = tune.value.listing_visibility
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

locals {
  workspaces = merge(flatten([for org, project in var.workspaces :
    [for proj, workspace in project : { for ws in workspace : replace(format(var.key_name_format, org, proj, ws), "/\\W|_|\\s/", "-") => {
      org           = org
      project       = proj
      ws            = ws
      role_name     = replace(format(var.role_name_format, org, proj, ws), "/\\W|_|\\s/", "-")
      identity_name = format(var.identity_name_format, org, proj, ws)
    } }]
  ])...)
}

resource "vault_jwt_auth_backend_role" "roles" {
  for_each = local.workspaces

  namespace = var.namespace

  backend         = vault_jwt_auth_backend.this.path
  role_name       = each.value.role_name
  bound_audiences = var.bound_audiences
  role_type       = "jwt"

  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${each.value.org}:project:${each.value.project}:workspace:${each.value.ws}:run_phase:*"

    terraform_organization_name = each.value.org
    terraform_project_name      = each.value.project
    terraform_workspace_name    = each.value.ws
  }

  claim_mappings = var.claim_mappings
  user_claim     = "terraform_full_workspace"

  token_policies         = var.token_policies
  token_ttl              = var.token_ttl
  token_max_ttl          = var.token_max_ttl
  token_explicit_max_ttl = var.token_explicit_max_ttl
}

resource "vault_identity_entity" "workspaces" {
  for_each = var.enable_identity_management ? local.workspaces : {}

  namespace = var.namespace

  name              = each.value.identity_name
  external_policies = true
  metadata = {
    terraform_organization_name = each.value.org
    terraform_project_name      = each.value.project
    terraform_workspace_name    = each.value.ws
  }

  lifecycle {
    precondition {
      condition     = !can(regex("\\*+", each.value.ws))
      error_message = "Identity Entity management only works when workspace names contains no wildcard"
    }
  }
}

resource "vault_identity_entity_alias" "workspaces" {
  for_each = var.enable_identity_management ? local.workspaces : {}

  namespace = var.namespace

  name           = "organization:${each.value.org}:project:${each.value.project}:workspace:${each.value.ws}"
  mount_accessor = vault_jwt_auth_backend.this.accessor
  canonical_id   = vault_identity_entity.workspaces[each.key].id

  lifecycle {
    precondition {
      condition     = !can(regex("\\*+", each.value.ws))
      error_message = "Identity Entity management only works when workspace names contains no wildcard"
    }
  }
}
