resource "github_actions_repository_permissions" "this" {
  repository      = var.repository
  enabled         = true
  allowed_actions = "selected"

  allowed_actions_config {
    github_owned_allowed = true
    verified_allowed     = true
    patterns_allowed     = []
  }
}

resource "github_workflow_repository_permissions" "this" {
  repository                   = var.repository
  default_workflow_permissions = "read"
}
