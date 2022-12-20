module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "centos-vpc"
  cidr   = var.cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "centos-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_cp" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

module "ecs-fargate" {
  source  = "umotif-public/ecs-fargate/aws"
  version = "~> 6.1.0"

  name_prefix        = "centos-fargate"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  cluster_id = aws_ecs_cluster.ecs_cluster.id

  task_container_image   = var.image
  task_definition_cpu    = 256
  task_definition_memory = 512

  task_container_port             = 80
  task_container_assign_public_ip = true
  load_balanced                   = false

  target_groups = [
    {
      target_group_name = "centos-project"
      container_port    = 80
    }
  ]

  health_check = {
    port = "traffic-port"
    path = "/"
  }

  tags = {
    Environment = "test"
    Project     = "Test"
  }
}

    module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.6.0"
}

resource "aws_s3_bucket_object" "centos-S3" {
  bucket = "tf-state"
  key    = "tf-state"
}
