# Variables

| Name | Description |
| :--- | :---------- |
| env_type | Type of environment (prod, test, stage, dev, ...) |
| prefix | A prefix that will be added to the cloud resources|
| aws_region | AWS regions (name of primary and secondary regions for your mulit-region setup) |
| vpc | VPC ID (for primary and secondary regions) |
| tags | Tags which will be attached to AWS resources |
| aurora | Configuration for aurora postgresql db (db engine, version, instance class, ...) |
| eks | Name of primary and secondary eks cluster created using [eks-setup module](../eks-setup/) |
| todo_app | URL of the todo app that will be deployed on the primary and secondary eks cluster (the url is required to create route53 healthcheck which will be later used for automtatic dns failover) |

Note: Most of the values listed here will be obtained after running the [pre-requisites](../pre-requisites/) and [eks-setup](../eks-setup/) modules.