output "auth_mount_accessor" {
  description = "Auth mount accessor"
  value       = vault_jwt_auth_backend.this.accessor
}

output "workspaces" {
  description = "Workspace information"
  value = { for k, v in local.workspaces : v.org => tomap({ (v.ws) = merge(
    {
      org       = v.org
      project   = v.proj
      workspace = v.ws
      role      = vault_jwt_auth_backend_role.roles[k].role_name
    },
    var.enable_identity_management ? {
      identity_name  = vault_identity_entity.workspaces[k].name
      identity_id    = vault_identity_entity.workspaces[k].id
      identity_alias = vault_identity_entity_alias.workspaces[k].name
    } : {}
  ) })... }
}
