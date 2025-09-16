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

unit "vpc" {
  source = "../../../../../units/vpc"
  path   = "vpc"

  values = {
    name = "${local.project}-${local.env}-vpc"
    cidr = "10.0.0.0/16"

    azs             = ["${local.region}a", "${local.region}b"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway     = true
    single_nat_gateway     = true
    one_nat_gateway_per_az = false

    enable_dns_hostnames = true
    enable_dns_support   = true

    enable_flow_log                      = false
    create_flow_log_cloudwatch_iam_role  = false
    create_flow_log_cloudwatch_log_group = false

    private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = "1"
    }

    public_subnet_tags = {
      "kubernetes.io/role/internal-elb" = "1"
    }

    tags = {
      Name      = "${local.project}-${local.env}-vpc"
      ManagedBy = "Terragrunt"
    }
  }
}
