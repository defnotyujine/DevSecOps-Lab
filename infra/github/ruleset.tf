resource "github_repository_ruleset" "main" {
  name        = "main-branch-protection"
  repository  = var.repository
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion            = true
    required_signatures = true

    required_status_checks {
      strict_required_status_checks_policy = true

      required_check {
        context = "scan"
      }
    }

    pull_request {
      # GitHub never lets an author approve their own PR.
      # Raise to 1+ if a collaborator joins.
      required_approving_review_count = 0
      dismiss_stale_reviews_on_push   = true
    }
  }
}
