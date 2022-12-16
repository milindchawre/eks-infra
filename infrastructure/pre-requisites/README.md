# Terraform remote state


### Intro

Before we build the EKS multi-region setup using terraform. We need a 
- remote storage to store terraform state files
- image registry (ECR repo) to store the docker images of applications
- [IAM OIDC identity provider](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) to grant github actions access to AWS (needed to deploy EKS and kubernetes applications)
- IAM OIDC identiy provider will create an IAM role that will be assumed by github actions for deployment, this IAM role will be required in EKS terrafrom code to grant admin level privileges on EKS
- Route53 domain to expose our application and ACM certificates to secure expose your application using https protocol

The terraform code here will create these required resources and this is onetime activity.

***Note:** The terraform state of these pre-requisites resources are not not stored anywhere remotely. This is might change in future.*

### Steps to deploy

The resources can be deployed either [manually](#manually) or [using github actions](#using-github-actions). Prior to the deployment you need to be [prepared](#preparations).

#### Preparations
Make sure the values in [vars.tfvars](vars.tfvars) are appropriate one as per your needs. [This guide](values.md) outlines each values in `vars.tfvars`.

#### Manually

1. Login with your aws account with `aws` cli
   ```shell
   # Set AWS credentials (access key, secret key, region)
   aws configure --profile wetravel
   export AWS_PROFILE=wetravel
   ```
2. Make sure `vars.tfvars` contains correct values (refer preparations section above) and also make sure that the`terraform` is installed on your system (version >= v1.3.0).
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

#### Post Deployment
Once the pre-requisites resources are created, take a note of below points:
- ACM certificate ARN
- Route53 domain name
- S3 bucket name
- DynamoDB table name
- ECR Repo name
- OIDC IAM role ARN
- AWS Regions
These details will be required when you bring EKS cluster and deploy app on it.