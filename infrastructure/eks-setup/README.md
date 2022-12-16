# EKS cluster

### Intro

This is a terraform code to setup EKS cluster on AWS in multi-region setup. The code also creates VPC and installs [externals-dns](https://github.com/kubernetes-sigs/external-dns) and [ALB controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html) on EKS cluster.

### Steps to deploy

The resources can be deployed either [manually](#manually) or [using github actions](#using-github-actions). Prior to the deployment you need to be [prepared](#preparations).

#### Preparations
Make sure the values in [seoul-prod.tfvars](environments/seoul-prod.tfvars) and [osaka-prod.tfvars](environments/osaka-prod.tfvars) are appropriate one as per your needs. [This guide](values.md) outlines each values in these tfvars file.

#### Using Github Actions
To create EKS cluster use [this github workflow](../../.github/workflows/terraform-multi-region-eks-prod.yml).

#### Manually

For multi-region deployment, below steps need to be repeated for each AWS region (primary and secondary region for your multi-region setup).

1. Login with your aws account with `aws` cli
   ```shell
   # Set AWS credentials (access key, secret key, region) for both regions
   # set one of the below aws profile based on the region in which you are setting up the cluster
   # set the profile on alternate runs (once for each region [primary and secondary aws region])
   # ap-northeast-2 region
   aws configure --profile wetravel-seoul
   export AWS_PROFILE=wetravel-seoul

   # ap-northeast-3 region
   aws configure --profile wetravel-osaka
   export AWS_PROFILE=wetravel-osaka
   ```
2. Make sure [seoul-prod.tfvars](environments/seoul-prod.tfvars) and [osaka-prod.tfvars](environments/osaka-prod.tfvars) contains correct values (refer preparations section above) and also make sure that the `terraform` is installed on your system (version >= v1.3.0).
3. Make sure [seoul-prod backend](backend/seoul-prod/backend.hcl) and [osaka-prod backend](backend/osaka-prod/backend.hcl) contains correct values, its required to store terraform remote state of our cluster.
4. Initialize terraform
   ```shell
   # switch to correct directory
   cd infrastructure/eks-setup
   # Make sure previous terraform init config is removed
   rm -rf .terraform
   # initialize terraform
   # point to correct backend file either osaka-prod or seoul-prod
   terraform init -backend-config=backend/<osaka-prod or seoul-prod>/backend.hcl
   ```
5. Plan
   ```shell
   # update the command with the preferred tfvars recipe 
   # point to correct tfvars file either osaka-prod or seoul-prod
   terraform plan -var-file=environments/<osaka-prod or seoul-prod>.tfvars -out tfplan
   ```
6. Apply
   ```shell
   terraform apply "tfplan"
   ```
7. To destroy plan with destroy and apply again (USE only when you want to destroy your environment)
   ```shell
   # update the command with the preferred tfvars recipe
   terraform plan -var-file=environments/<osaka-prod or seoul-prod>.tfvars -out tfplan -destroy
   terraform apply "tfplan"
   ```

#### Post Deployment

Once the AWS resources are created, take a note of below points (few of them can be obtained once you run [pre-requisities module](../pre-requisites/)):
- AWS Region
- EKS cluster name
- ACM certificate ARN
- Route53 domain name
- ECR Repo name
- OIDC IAM role ARN
- AWS VPC ID
These details will be required when deploy database using [db-setup module](../db-setup/) and also for the deployment of [todo app](https://github.com/milindchawre/todo) on EKS cluster.

Now move further with database deployment using [db-setup module](../db-setup/).