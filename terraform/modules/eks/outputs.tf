output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.production_cluster.name
}

output "oidc_provider_url" {
  description = "The OIDC provider URL used by the EKS cluster for IAM identity mapping."
  value       = aws_eks_cluster.production_cluster.identity[0].oidc[0].issuer
}

output "eks_cluster_certificate_authority" {
  description = "The base64 encoded certificate data required to authenticate with the EKS cluster."
  value       = aws_eks_cluster.production_cluster.certificate_authority[0].data
}

output "eks_cluster_endpoint" {
  description = "The endpoint URL to connect to the EKS cluster's Kubernetes API server."
  value       = aws_eks_cluster.production_cluster.endpoint
}
