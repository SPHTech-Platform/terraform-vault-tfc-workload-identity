output "auth_mount_accessor" {
  description = "Auth mount accessor"
  value       = vault_jwt_auth_backend.this.accessor
}

output "workspaces" {
  description = "Workspace information"
  value = { for org, workspaces in var.workspaces : org => {
    for ws in workspaces : ws => merge(
      {
        organization = org
        workspace    = ws

        role = vault_jwt_auth_backend_role.roles["${org}-${ws}"].role_name
      },
      var.enable_identity_management ? {
        identity_name  = vault_identity_entity.workspaces["${org}-${ws}"].name
        identity_id    = vault_identity_entity.workspaces["${org}-${ws}"].id
        identity_alias = vault_identity_entity_alias.workspaces["${org}-${ws}"].name
      } : {}
    )
  } }
}
