resource "github_repository" "this" {
  name = var.repository

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  # This resource only exists here to manage security_and_analysis. Every
  # other setting (has_issues, description, merge options, etc.) already
  # exists on the repo and is left alone rather than reset by Terraform.
  lifecycle {
    ignore_changes = [
      allow_auto_merge, allow_merge_commit, allow_rebase_merge,
      allow_squash_merge, allow_update_branch, archive_on_destroy,
      archived, auto_init, delete_branch_on_merge, description,
      gitignore_template, has_discussions, has_downloads, has_issues,
      has_projects, has_wiki, homepage_url,
      ignore_vulnerability_alerts_during_read, is_template,
      license_template, merge_commit_message, merge_commit_title,
      squash_merge_commit_message, squash_merge_commit_title, topics,
    ]
  }
}
