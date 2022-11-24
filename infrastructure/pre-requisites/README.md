# Terrafrom remote state


### Intro

Before we build the EKS setup using terraform. We need a 
- remote storage to store terraform state files
- image registry (ECR repo) to store the docker images of applications
- [IAM OIDC identity provider](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) to grant github actions access to AWS (needed to deploy EKS and kubernetes applications)

The terraform code here will create these required resources and this is onetime activity.

### Steps to deploy

1. Login with your aws account with `aws` cli
   ```shell
   # Set AWS credentials (access key, secret key, region)
   aws configure --profile wetravel
   export AWS_PROFILE=wetravel
   ```
2. Make sure `vars.tfvars` contains correct values (bucket name, dynamodb table) and `terraform` installed on your system (version >= v1.3.0).
3. Initialize terraform
   ```shell
   # switch to correct directory
   cd infrastructure/pre-requisites
   # initialize terraform
   terraform init
   ```
4. Plan
   ```shell
   # update the command with the preferred tfvars recipe 
   terraform plan -var-file=vars.tfvars -out tfplan
   ```
5. Apply
   ```shell
   terraform apply "tfplan"
   ```
6. To destroy plan with destroy and apply again (USE only when you want to destroy your environment)
   ```shell
   # update the command with the preferred tfvars recipe 
   terraform plan -var-file=vars.tfvars -out tfplan -destroy
   terraform apply "tfplan"
   ```