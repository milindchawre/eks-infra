# Variables

| Name | Description |
| :--- | :---------- |
| env_type | Type of your environment (prod, test, dev, staging, ...) |
| prefix | This prefix will be attached to AWS resources |
| tags | Tags which will be attached to AWS resources |
| region | AWS region in which the cluster will be deployed |
| cluster_version | Version of EKS cluster |
| node_pool_app | Configuration for EKS nodepool (VM name & type, max & min nodecount) |
| aws_alb_controller | Configuration for ALB controller (k8s namespace, helm chart version, timeout, ALB config file, replica count, ...) |
| external_dns | Configuration for external-dns (k8s namespace, helm chart version, timeout, domain name, dns sync policy, ...) |
| oidc_iam_role | IAM role which will be assumed by Github OIDC client (it is created in [pre-requisites module](../pre-requisites/)) |
| vpc | Configuration for VPC (cidr, private subnets, ...) |

Note: Most of the values listed here will be obtained after running the [pre-requisites module](../pre-requisites/).