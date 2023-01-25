#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "msa-maker-cluster" {
  name = local.cluster_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "msa-maker-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.msa-maker-cluster.name
}

resource "aws_iam_role_policy_attachment" "msa-maker-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.msa-maker-cluster.name
}

resource "aws_security_group" "msa-maker-cluster" {
  name        = format("%s-eks-master", local.name_prefix)
  description = "msa-maker cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #tags = {
  #  Name = "terraform-eks-demo"
  #}
  tags = merge(local.tags, {Name = format("%s-cluster-security_group", local.name_prefix)})
}

#resource "aws_security_group_rule" "msa-maker-cluster-ingress-workstation-https" {
#  cidr_blocks       = [local.workstation-external-cidr]
#  description       = "Allow workstation to communicate with the cluster API Server"
#  from_port         = 443
#  protocol          = "tcp"
#  security_group_id = aws_security_group.msa-maker-cluster.id
#  to_port           = 443
#  type              = "ingress"
#}

resource "aws_eks_cluster" "master_node" {
  name     = local.cluster_name
  role_arn = aws_iam_role.msa-maker-cluster.arn
  version                   = "1.22"
  vpc_config {
    security_group_ids = [aws_security_group.msa-maker-cluster.id]
    #subnet_ids         = aws_subnet.demo[*].id
    subnet_ids = tolist(data.aws_subnet_ids.private.ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.msa-maker-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.msa-maker-cluster-AmazonEKSVPCResourceController,
  ]
}