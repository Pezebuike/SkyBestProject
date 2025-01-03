# AWS Multi-region Infrastructure Provisioning with Terraform

## Overview
This project demonstrates the creation and deployment of an AWS multi-region infrastructure using **Terraform**, adhering to industry best practices for security, scalability, and maintainability. It also showcases the integration of CI/CD pipelines for seamless infrastructure management.

## Features

### Key Infrastructure Components
1. **Subnet Architecture**:
   - **Public Subnets**: Route traffic through an Internet Gateway (IGW).
   - **Private Subnets**: Route traffic through a NAT Gateway for secure outbound access.
   - **Secure Subnets**: Completely isolated with no routes to IGW or NAT Gateway.

   ![Subnet Architecture](https://via.placeholder.com/800x400?text=Subnet+Architecture+Diagram)

2. **Load Balancer**:
   - Deployed in Public Subnets across two Availability Zones (AZs).
   - Configured with Listeners and Target Groups to handle incoming traffic efficiently.

   ![Load Balancer Architecture](https://via.placeholder.com/800x400?text=Load+Balancer+Diagram)

3. **Auto Scaling Group (ASG)**:
   - Distributed across two AZs in Private Subnets.
   - Integrated with the Application Load Balancer (ALB) for automatic scaling.
   - Configurations:
     - **Desired Instances**: 1
     - **Minimum Instances**: 1
     - **Maximum Instances**: 1
   - Instances:
     - Do not have public IPs.
     - Are accessed securely via SSM or EC2 Instance Connect Endpoint.
     - Run user data scripts on startup to deploy a Docker image or WAR/JAR file.
     - Security groups block port 22 for enhanced security.

   ![Auto Scaling Group Diagram](https://via.placeholder.com/800x400?text=Auto+Scaling+Group+Diagram)

### CI/CD Pipeline Integration
- **On Commit to Any Branch**:
  - Executes `terraform init`, `terraform validate`, `terraform fmt`, and `terraform plan`.
  - Optionally performs a Checkov security scan.

- **On Pull Request Creation**:
  - Runs `terraform init`, `terraform validate`, `terraform fmt`, and `terraform plan`.
  - Provides detailed plans for reviewer visibility.

- **On Merge to Master/Main**:
  - Applies infrastructure changes using a GitOps approach with `terraform apply`.

   ![CI/CD Pipeline Flow](https://via.placeholder.com/800x400?text=CI%2FCD+Pipeline+Flow+Diagram)

### Terraform State Management
- **State Storage**:
  - Stored securely in an S3 bucket.
  - Features cross-region replication, versioning, and encryption.

- **State Locking**:
  - Enabled via DynamoDB to prevent concurrent modifications.

   ![Terraform State Management Diagram](https://via.placeholder.com/800x400?text=Terraform+State+Management+Diagram)

## Getting Started

### Prerequisites

1. **Install Terraform**:
   - [Terraform Installation Guide](https://developer.hashicorp.com/terraform/install)

2. **Install AWS CLI**:
   - [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Configuration
1. **Configure AWS CLI**:
   - Set up your credentials using:
     ```bash
     aws configure
     ```

2. **Initialize Terraform Backend**:
   ```bash
   terraform init
   ```

3. **Preview Changes**:
   ```bash
   terraform plan
   ```

4. **Apply Changes**:
   ```bash
   terraform apply --auto-approve
   ```

5. **Verify Deployment**:
   - Navigate to the AWS Console under Load Balancers.
   - Access the application using the Load Balancer DNS name.



# Build and Deploy Infrastructure Workflow

This GitHub Actions workflow automates the process of building an Amazon Machine Image (AMI) using HashiCorp Packer and deploying infrastructure using HashiCorp Terraform.

## Workflow Overview

### Name
**Build and Deploy Infrastructure**

### Trigger
The workflow is triggered by a `push` event to the `main` branch.

### Jobs
1. **Build AMI with Packer**
2. **Deploy Infrastructure with Terraform**

---

## Workflow Details

### Job: Build AMI with Packer
This job creates an Amazon Machine Image (AMI) using Packer.

#### Steps:
1. **Checkout Code**: Retrieves the latest code from the repository.
2. **Install Packer**: Installs HashiCorp Packer on the runner.
3. **Configure AWS Credentials for Packer**: Sets up AWS credentials using GitHub Secrets for Packer.
4. **Validate Packer Template**: Validates the Packer template file (`packer-template.json`).
5. **Build AMI**: Executes the Packer build process and extracts the AMI ID as an output for subsequent jobs.

#### Outputs:
- `ami_id`: The ID of the newly created AMI.

---

### Job: Deploy Infrastructure with Terraform
This job provisions infrastructure using Terraform, dependent on the AMI built in the previous job.

#### Steps:
1. **Checkout Code**: Retrieves the latest code from the repository.
2. **Set Up Terraform**: Installs HashiCorp Terraform on the runner.
3. **Configure AWS Credentials for Terraform**: Sets up AWS credentials using GitHub Secrets for Terraform.
4. **Initialize Terraform**: Initializes the Terraform working directory.
5. **Validate Terraform**: Validates the Terraform configuration.
6. **Plan Terraform Deployment**: Generates a Terraform execution plan using `terraform.tfvars`.
7. **Apply Terraform Deployment**: Applies the Terraform execution plan to deploy the infrastructure.

---

## Prerequisites

1. **GitHub Secrets**:
   - `AWS_ACCESS_KEY_ID`: AWS access key.
   - `AWS_SECRET_ACCESS_KEY`: AWS secret access key.
   - `AWS_DEFAULT_REGION`: AWS region for deployments.

2. **Packer Template**:
   - Place your Packer template in `packer_build/packer-template.json`.

3. **Terraform Configuration**:
   - Place your Terraform files in `aws_petclinic_region1/`.
   - Ensure a `terraform.tfvars` file exists for environment-specific variables.

---

## Usage

1. Push your code to the `main` branch to trigger the workflow.
2. Monitor the workflow in the Actions tab.
3. Verify the created AMI and deployed infrastructure in your AWS account.

---

## Notes
- Modify `packer-template.json` and `terraform.tfvars` as required for your specific use case.
- Ensure all required AWS permissions are granted for the provided credentials.
- Test the workflow in a staging environment before running in production.

---

## License
This workflow is open-sourced under the [MIT License](LICENSE).



## Results
Upon successful deployment, the application will be running and accessible via the provided Load Balancer DNS name.

## Best Practices
- Use modular Terraform code for scalability and reusability.
- Secure sensitive data using encryption and IAM roles.
- Regularly scan infrastructure code with tools like Checkov or Terrascan.
- Implement monitoring and alerting for critical infrastructure components.

## References
- [Terraform Documentation](https://developer.hashicorp.com/terraform)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli)

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contribution
Contributions are welcome! Fork this repository, create a branch, and submit a pull request with your changes.

---

For any questions or issues, feel free to open an issue in this repository or contact the maintainer.
