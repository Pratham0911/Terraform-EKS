provider "aws" {
  region = "us-east-1" 
}
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.my_eks_role.arn
  vpc_config {
    subnet_ids         = ["subnet-1234566778", "subnet-987654321"] #Use_your_subnet_IDs
    security_group_ids = ["sg-12345as098765"]                      #use_your_security_Group
    endpoint_public_access = true
    endpoint_private_access = false
  }
  tags = {
    Environment = "Production"
  }
}
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.my_eks_node_role.arn
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  subnet_ids         = ["subnet-11234567890", "subnet-9876543221234"] #use_your_subnet_ids
  instance_types     = ["t2.micro"]  #describe_instance_type
  ami_type           = "AL2_x86_64"
  remote_access {
    ec2_ssh_key = "my-ssh-key"
  }
  tags = {
    Environment = "Production"
  }
}
resource "aws_iam_role" "my_eks_role" {
  name               = "my-eks-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role" "my_eks_node_role" {
  name               = "my-eks-node-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
  tags = {
    Environment = "Production"
  }
}
