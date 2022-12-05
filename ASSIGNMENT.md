# Project Description

The take-home project is about building a pipeline for the ToDo application: https://github.com/wtrvl/todo
(You can use your own application either).

### Task:
Build Infrastructure as a code for a simple ToDo application
1. Use the provided AWS account ( credential file attached )
2. Create infrastructure as code with Terraform
* Create a Kubernetes Cluster with Terraform (EKS)
* Setup RDS with multi-az (Terraform)
* Setup load balancers (Terraform) and enable WAF for DDoS (WAF can be done manually)
* Push deployment configuration files to any GitHub account and provide us access to our team. (you can use a public repo)
3. Create a deployment pipeline for the ToDo application
4. Create basic documentation for your environment.
Our expectations are:
* [Must have]: Web site is accessible from the Internet and is DDoS protected and scalable.
* [Good to have]: Pipeline is setup with Gitlab or a similar tool. Clear documentation.
* [Nice to have]: Supports multi-region deployment (If you have multi-region experience)
* If you have questions - email us. 
* It should take you up to 2 weeks to do the homework. 
How to submit:
* Upload your completed project to your GitHub which can be accessible to our team and then
 Deadline: 2 weeks
!! important notice 
* You should use your name as a prefix for all AWS resources that you are gonna create and You should use the below regions. Please don't use the other regions.
* regions: ap-northeast-2 and ap-northeast-3 you can use.
