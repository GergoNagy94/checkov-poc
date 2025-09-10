locals {
  env             = "development"
  region          = "eu-central-1"
  project         = "checkov-test"
  project_version = "1.0.0"

  development_account_id    = "567749996660"
  development_account_email = "hello@gergo.com"
  organization_id           = "0-0000000000"
  organization_root_id      = "r-0000"

}

unit "s3"{
  source="../../../../../units/web/s3"
  path="s3"

  values = {
    bucket  = "${local.env}-${local.region}-${local.project}"

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false

    attach_policy = false
    policy        = null

    versioning = {
        enabled = true
      }
  }
}
