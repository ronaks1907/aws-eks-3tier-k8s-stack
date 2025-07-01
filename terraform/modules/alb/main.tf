data "aws_caller_identity" "current" {}

# IAM Policy for ALB Controller
resource "aws_iam_policy" "alb_ingress_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for the ALB Ingress Controller"
  policy      = file("modules/alb/alb-ingress-policy.json")

  tags = {
    Name        = "${var.environment}-alb-controller-policy"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# IAM Role for ALB Controller
resource "aws_iam_role" "alb_ingress_controller_role" {
  name = "${var.environment}-${var.cluster_name}-alb-ingress-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.oidc_provider_url, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:alb-ingress-controller"
          }
        }
      }
    ]
  })

  tags = {
    Name           = "${var.environment}-${var.cluster_name}-alb-controller-role"
    Environment    = var.environment
    Cluster        = var.cluster_name
    ServiceAccount = "alb-ingress-controller"
    ManagedBy      = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# IAM ALB Role policy attachment
resource "aws_iam_role_policy_attachment" "alb_ingress_policy_attachment" {
  role       = aws_iam_role.alb_ingress_controller_role.name
  policy_arn = aws_iam_policy.alb_ingress_controller.arn
}

# Kubernetes Service Account
resource "kubernetes_service_account" "alb_ingress_sa" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_controller_role.arn
    }
  }
  depends_on = [null_resource.connect_to_eks]
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for ALB"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.environment}-${var.cluster_name}-alb-sg"
    Environment = var.environment
    Cluster     = var.cluster_name
    ManagedBy   = "Terraform"
  }
}

# EKS Context Config
resource "null_resource" "connect_to_eks" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
  }
}

# Helm Release: ALB Controller
resource "helm_release" "alb_ingress_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  values = [<<EOF
clusterName: "${var.cluster_name}"
region: "${var.region}"
vpcId: "${var.vpc_id}"
subnetIds:
  - ${var.app_subnet_1_id}
  - ${var.app_subnet_2_id}
securityGroup:
  id: "${aws_security_group.alb_sg.id}"
replicaCount: 2
serviceAccount:
  create: false
  name: "alb-ingress-controller"
EOF
  ]

  depends_on = [
    null_resource.connect_to_eks,
    kubernetes_service_account.alb_ingress_sa
  ]
}
