terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.vpc_region]
    }
  }
}
# resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#     policy_arn  = "arn:aws:iam::691575244851:role/EKS-Cluster"
#     role = aws_iam_role.eks_cluster.name

  
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
#     policy_arn  = "arn:aws:iam::691575244851:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
#     role = aws_iam_role.eks_cluster.name
  
# }

resource "aws_eks_cluster" "aws_eks" {
    name = "Tes-Demo"
    role_arn = "arn:aws:iam::691575244851:role/EKS"

    vpc_config {
        subnet_ids = ["subnet-0925b04d79caa625a","subnet-0adf449365f26d140"]

      
    }
    tags = {
      Name = "Mohanram"
    }

  
}

resource "aws_iam_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::691575244851:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
    
    name = "test"
  
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::691575244851:role/EKS"
    role = "test"
  
}



resource "aws_eks_node_group" "node" {
    cluster_name = aws_eks_cluster.aws_eks.name
    node_group_name = "DEMO-Test"
    node_role_arn = "arn:aws:iam::691575244851:role/EKS"
    subnet_ids = ["subnet-0925b04d79caa625a","subnet-0adf449365f26d140"]
    tags = {
        Name = "Mohanram"
    }
  
  scaling_config {
    desired_size = 3
    max_size = 5
    min_size = 3
  }
}