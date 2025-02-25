# Day-4 | Terraform State DeepDive | Remote Backend | State Locking

- [vid](https://www.youtube.com/watch?v=UhNpn7lVRBY&list=PLdpzxOOAlwvI0O4PeKVV1-yJoX2AqIWuf&index=4)

---

### **Terraform Day 4 - Terraform State Deep Dive, Remote Backend & State Locking**

**Instructor:** Abhishek Veeramalla

------

## **📌 Agenda for the Lecture**

1. Understanding Terraform State
   - What is a state file?
   - Why is it important?
   - Advantages and drawback of the Terraform state file.
2. Terraform Backend & Remote State
   - What is a backend?
   - Storing Terraform state in AWS S3 (remote backend).
3. Terraform State Locking
   - Why is state locking important?
   - Implementing state locking using AWS DynamoDB.
4. Practical Demonstration
   - Writing Terraform configuration with a remote backend.
   - Creating an AWS S3 bucket and DynamoDB for Terraform state management.
   - Running Terraform commands to verify behavior.

------

## **1️⃣ What is Terraform State?**

- The **Terraform state file (`terraform.tfstate`)** keeps track of all infrastructure managed by Terraform.
- It stores **resource IDs, configurations, and dependencies**.
- Acts as Terraform’s **"memory"**, ensuring that Terraform knows what has already been created.

### **🟢 Why is Terraform State Important?**

- ✅ **Tracks infrastructure**: Prevents duplicate resource creation.
- ✅ **Detects changes**: Terraform compares the state file with the actual infrastructure.
- ✅ **Speeds up execution**: Terraform doesn’t have to query every resource manually.
- ✅ **Helps in updates & deletions**: Ensures Terraform modifies the correct resources.

### **🔴 Drawbacks of Storing State Locally**

- ❌ **Sensitive Information Exposure**: The state file contains **secrets, credentials, and API keys**.
- ❌ **No Collaboration**: If multiple DevOps engineers work on Terraform, each must manually update the state file.
- ❌ **Risk of Losing the State File**: If the file is deleted, Terraform loses track of the infrastructure.

------

## **2️⃣ What is a Terraform Backend?**

- A **backend** defines **where Terraform stores its state file**.
- By default, Terraform saves the state **locally** (`terraform.tfstate`).
- **Best Practice**: Use a **remote backend** (AWS S3, Azure Blob Storage, Terraform Cloud).

### **🟢 How does Remote Backend work?**
- source code is going to be push to github (or other version control tool)
- statefile is going to be updated to remote control automaticlly. That way, it prevent statefile lost or outdated. --> solves the drawback of storing statefile locally

### **🟢 Why Use a Remote Backend?**

- ✅ **Centralized State Storage**: No need to manually share state files.
- ✅ **Security**: Sensitive data is stored securely (e.g., encrypted in S3).
- ✅ **Collaboration**: Multiple team members can apply changes safely.
- ✅ **State Locking Support**: Prevents concurrent changes.

### **📌 Storing Terraform State in AWS S3**

1. **Create an S3 Bucket** to store the Terraform state file.
2. **Modify `backend.tf` to use S3 as the remote backend**.
3. **Run `terraform init` to migrate local state to S3**.

#### **Terraform Configuration for S3 Backend (`backend.tf`)**

- terraform backend [doc](https://developer.hashicorp.com/terraform/language/backend)

```
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
```

### **🔹 Steps to Implement Remote Backend**

- 1️⃣ **Create an S3 bucket**

```
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
}
```

- 2️⃣ **Configure Terraform to use the S3 backend (`backend.tf`)**
- 3️⃣ **Run `terraform init` to migrate the state to S3**

------

## **3️⃣ Terraform State Locking (Using DynamoDB)**

- **Problem:** What happens if two DevOps engineers run `terraform apply` at the same time?
- **Solution:** **Terraform state locking** ensures only one person modifies the infrastructure at a time.
- Terraform supports **state locking** using **AWS DynamoDB**.

### **📌 Why is State Locking Important?**

- ✅ **Prevents Conflicts**: Avoids two engineers modifying the same resources simultaneously.
- ✅ **Ensures Data Consistency**: Terraform waits if another process is already making changes.
- ✅ **Improves Collaboration**: Ensures smooth teamwork.

### **📌 Setting Up State Locking with DynamoDB**

1. **Create a DynamoDB table for state locking**
2. **Modify `backend.tf` to enable locking**
3. **Run `terraform init` to apply locking configuration**

#### **Terraform Configuration for DynamoDB Locking**

```
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

#### **Modify `backend.tf` to Use DynamoDB Locking**

```
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### **🔹 Steps to Implement State Locking**

- 1️⃣ **Create a DynamoDB table** (Terraform code above).
- 2️⃣ **Update `backend.tf` to reference the table**.
- 3️⃣ **Run `terraform init` again to enable locking**.

------

## **4️⃣ Practical Demonstration**

### **🔹 Step 1: Initialize the Project**

```
terraform init
```

- Detects backend configuration and migrates state to S3.

### **🔹 Step 2: Verify the State File is in S3**

- Open AWS S3 and check for `terraform.tfstate`.

### **🔹 Step 3: Locking in Action**

- Run `terraform apply` in **one terminal window**.
- In **another terminal**, try running `terraform apply` again.
- The second command will **wait** until the lock is released.

------

## **5️⃣ Common Issues and Solutions**

| **Issue**                     | **Solution**                              |
| ----------------------------- | ----------------------------------------- |
| Lost state file               | Restore from remote backend (S3)          |
| Concurrent changes            | Use DynamoDB for locking                  |
| State file contains secrets   | Use Terraform Vault or AWS KMS encryption |
| Merge conflicts in state file | Use remote backend instead of local state |

------

## **6️⃣ Key Takeaways**

- ✅ **Terraform State is Essential**: It tracks infrastructure changes.
- ✅ **Use Remote State Storage**: Store state in **AWS S3, Azure Blob, or Terraform Cloud**.
- ✅ **Enable State Locking**: Use **DynamoDB** to prevent conflicts.
- ✅ **Never Push `terraform.tfstate` to Git**: Add it to `.gitignore`.

------