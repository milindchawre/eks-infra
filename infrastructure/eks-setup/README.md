# EKS cluster

### Intro

This is a terraform code to setup EKS cluster on AWS. The code also creates VPC, Postgres RDS and installs [externals-dns](https://github.com/kubernetes-sigs/external-dns) and [ALB controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html) on EKS cluster.

### Steps to deploy

The resources can be deployed either [manually](#manually) or [using github actions](#using-github-actions). Prior to the deployment you need to be [prepared](#preparations).

#### Preparations
Make sure the values in [production.tfvars](environments/production.tfvars) are appropriate one as per your needs. [This guide](values.md) outlines each values in `production.tfvars`.

#### Using Github Actions
To create EKS cluster use [this github workflow](../../.github/workflows/terraform-eks-prod.yml).

#### Manually

1. Login with your aws account with `aws` cli
   ```shell
   # Set AWS credentials (access key, secret key, region)
   aws configure --profile wetravel
   export AWS_PROFILE=wetravel
   ```
2. Make sure `environments/production.tfvars` contains correct values (refer preparations section above) and also make sure that the `terraform` is installed on your system (version >= v1.3.0).
3. Make sure `backend/prod/backend.hcl` contains correct values (refer preparations section above), its required to store terraform remote state of our cluster.
3. Initialize terraform
   ```shell
   # switch to correct directory
   cd infrastructure/eks-setup
   # initialize terraform
   terraform init -backend-config=backend/prod/backend.hcl
   ```
4. Plan
   ```shell
   # update the command with the preferred tfvars recipe 
   terraform plan -var-file=environments/production.tfvars -out tfplan
   ```
5. Apply
   ```shell
   terraform apply "tfplan"
   ```
6. To destroy plan with destroy and apply again (USE only when you want to destroy your environment)
   ```shell
   # update the command with the preferred tfvars recipe 
   terraform plan -var-file=environments/production.tfvars -out tfplan -destroy
   terraform apply "tfplan"
   ```

#### Post Deployment

Once the AWS resources are created, take a note of below points:
- AWS Region
- EKS cluster name
- ACM certificate ARN
- Route53 domain name
- ECR Repo name
- OIDC IAM role ARN
These details will be required when deploy [todo app](https://github.com/milindchawre/todo) on EKS cluster.

Once you deploy the todo app by following the [README.md](https://github.com/milindchawre/todo/blob/main/README.md), create AWS WAF rule for DDoS protection (rate limit rule) by following [this guide](https://aws.amazon.com/premiumsupport/knowledge-center/waf-mitigate-ddos-attacks/) and attach this WAF to Application load balancer created by your application's ingress resource.