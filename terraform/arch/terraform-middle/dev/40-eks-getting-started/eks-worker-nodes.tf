#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "cluster-node" {
  name = format("%s-eks-node", local.name_prefix)

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.cluster-node.name
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.cluster-node.name
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.cluster-node.name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group#disk_size
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.master_node.name
  node_group_name = format("%s-%s%s-node", var.context.project, var.context.region_alias, var.context.env_alias)
  node_role_arn   = aws_iam_role.cluster-node.arn
  #subnet_ids      = aws_subnet.demo[*].id
  subnet_ids      = tolist(data.aws_subnets.private.ids)
  instance_types = ["m5.large"]
  disk_size = 50
  
  remote_access {
    ec2_ssh_key = var.keypair_name
  }

  scaling_config {
    desired_size = var.eks_min_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
