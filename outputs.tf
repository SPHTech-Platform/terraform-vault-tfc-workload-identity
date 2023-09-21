output "auth_mount_accessor" {
  description = "Auth mount accessor"
  value       = vault_jwt_auth_backend.this.accessor
}

output "workspaces" {
  description = "Workspace information"
  value = { for org, project in var.workspaces : org => merge([for proj, workspace in project :
    { for ws in workspace : ws => merge(
      {
        org       = org
        project   = proj
        workspace = ws
        role      = vault_jwt_auth_backend_role.roles["${org}-${proj}-${ws}"].role_name
      },
      var.enable_identity_management ? {
        identity_name  = vault_identity_entity.workspaces["${org}-${proj}-${ws}"].name
        identity_id    = vault_identity_entity.workspaces["${org}-${proj}-${ws}"].id
        identity_alias = vault_identity_entity_alias.workspaces["${org}-${proj}-${ws}"].name
      } : {}
    ) }]...)
  }
}
