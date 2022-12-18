# Contributing

### Tools

To contribute to this repo, make sure you have below tools configured on your workstation.
- AWS cli (any latest version should work)
- Terraform (version >= v1.3.0)

To deploy this codebase from your workstation, refer the README file.

### Improvements
There are few items that need to be improved in this codebase:
- Automate the deployment of [pre-requisites resources](infrastructure/pre-requisites) through github workflow.
- Move away the code for the s3 bucket and dyanomab table creation to separate module and later use this bucket to store the terraform state of remaining pre-requisites resources.
- Club all the github workflow together (pre-requities -> eks-setup -> db-setup -> todo-app deployment), so that it became one click deploment for entire setup.
- Automate the creation of [rate limiting AWS WAF rule](https://aws.amazon.com/premiumsupport/knowledge-center/waf-mitigate-ddos-attacks/) using [terraform resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rate_based_rule) and later add this waf rule to ALB ingress resource of todo app using [annotation provided by ALB controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/#wafv2-acl-arn).
- modify [eks-setup module](infrastructure/eks-setup/) so that multi-region eks cluster can be deployed in one go. Right now it is deployed by running terrafrom twice with different tfvars file.
- explore other AWS services like [Route53 Recovery Controller](https://aws.amazon.com/route53/application-recovery-controller/) and [AWS Global accelerator](https://aws.amazon.com/global-accelerator/) to achieve automatic DNS failover.
- create route53 failover records pointing to aurora postgresql db writer endpoints for automatic dns failover, refer [this guide](https://aws.amazon.com/blogs/networking-and-content-delivery/performing-route-53-health-checks-on-private-resources-in-a-vpc-with-aws-lambda-and-amazon-cloudwatch/). Right now the application configuration need to be updated to point to writer db endpoint incase of db failure, this can be automated once we have failover dns records.