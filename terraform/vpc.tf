module "vpc" {
  // https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.77.0
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = "192.168.0.0/16"

  azs             = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  public_subnets  = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  private_subnets = ["192.168.10.0/24", "192.168.11.0/24", "192.168.12.0/24"]
  intra_subnets   = ["192.168.20.0/24", "192.168.21.0/24", "192.168.22.0/24"]

  enable_nat_gateway = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
    "kubernetes.io/role/internal-elb"             = 1
  }

  //private_subnet_tags = {
  //  "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  //  "kubernetes.io/role/internal-elb"             = 1
  //}
}
