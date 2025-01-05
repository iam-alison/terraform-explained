# 1-Getting Start

### **Table of Content:**

1. Infrastructure as Code (IaC) Concept
   - Automating infrastructure provisioning using code.
2. Why Terraform is Essential for DevOps/Cloud Engineers
   - High demand in the job market.
3. Installing Terraform (MacOS, Linux, Windows)
   - official installation guide provided.
4. AWS Setup for Terraform
   - Authenticate Terraform with AWS.
5. First Terraform Project
   - Launch EC2 instance using Terraform.
   - Terraform life cycle (init, plan, apply, destroy).

------

### **Infrastructure as Code (IaC) - Why is it Important?**

- Manual Approach:
  - Logging into AWS, manually creating S3 buckets/EC2 instances.
  - Tedious for large-scale infrastructure.
- Automated Approach:
  - Use AWS CLI, scripting (Python, Boto3), or APIs.
  - Reduces manual effort but requires programming knowledge.
- IaC Tools:
  - Write infrastructure as code (JSON/YAML).
  - Examples: AWS CloudFormation, Azure Resource Manager, OpenStack Heat Templates.

------

### **Why Terraform Over Other IaC Tools?**

- Multi-Cloud Support:
  - Works with AWS, Azure, GCP, OpenStack, Kubernetes.
- Simplifies Learning Curve:
  - Learn Terraform once, use it across different cloud providers.
- Universal Tool:
  - Reduces the need to learn multiple IaC tools.
- Community Support:
  - Large community, mature tool, extensive documentation.

------

### **Installing Terraform:**
- follow this [document](https://developer.hashicorp.com/terraform/install)

### **Useful Plugin for VSCode:**
  - HashiCorp Terraform
  - HashiCorp HCL

### **AWS Setup for Terraform:**

1. Create AWS Access Keys:

   - IAM → Security Credentials → Create Access Key.

2. **Configure AWS CLI:**

   ```
   aws configure
   ```

   - Enter access key, secret key, default region (e.g., us-east-1).

3. Verify Setup:

   ```
   aws s3 ls
   ```

   

### **Writing Terraform Code:**

**Goal:** Launch EC2 instance using Terraform.

- **Create** `main.tf` (Terraform Configuration File):

  ```
  provider "aws" {
    region = "us-east-1"
  }
  
  resource "aws_instance" "example" {
    ami           = "ami-01816d07b1128cd2d"
    instance_type = "t2.micro"
  }
  ```


### **Terraform Workflow:**

1. **init:** Initializes provider plugins and configuration.
2. **plan**: Dry run to preview infrastructure changes.
3. **Apply**: Applies changes and provisions resources.
4. **destroy**: Deletes resources to avoid charges.

