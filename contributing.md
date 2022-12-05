# Contributing

### Tools

To contribute to this repo, make sure you have below tools configured on your workstation.
- AWS cli (any latest version should work)
- Terraform (version >= v1.3.0)

To deploy this codebase from your workstation, refer the README file.

### Improvements
There are few items that need to be improved in this codebase:
- Automate the deployment of [pre-requisites resources](infrastructure/pre-requisites) through github workflow.
- Move away the code for the s3 bucket and dyanomab table creation to separate module and use later use this bucket to store the terraform state of remaining pre-requisites resources.
- Club all the github workflow together (pre-requities -> eks-setup -> todo-app deployment), so that it became one click deploment for entire setup.
- Automate the creation of [rate limiting AWS WAF rule](https://aws.amazon.com/premiumsupport/knowledge-center/waf-mitigate-ddos-attacks/) using [terraform resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rate_based_rule) and later add this waf rule to ALB ingress resource of todo app using [annotation provided by ALB controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/#wafv2-acl-arn).
- Convert this codebase to have a DR setup (multi-region setup).
