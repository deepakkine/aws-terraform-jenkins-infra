# Three tier infra using AWS+Terraform+Git+Github

Description:

This project implements a robust, secure, and scalable three-tier application architecture on AWS, adhering to AWS best practices. The infrastructure is provisioned using Terraform and is fully automated with a Jenkins CI/CD pipeline. The setup is version-controlled using GitHub, ensuring streamlined deployment and environment management.

# Project Overview
The client required a reliable infrastructure for hosting a three-tier application with the following objectives:

Scalability and high availability.

Secure communication between tiers.

Low-latency content delivery.

This solution was designed and deployed to meet those requirements using cutting-edge DevOps tools and AWS services.

# Tech Stack & Tools
AWS Cloud: Hosting infrastructure and services.

Terraform: Infrastructure as Code (IaC) for provisioning and managing resources.

Jenkins: CI/CD pipeline automation.

GitHub: Version control and collaboration.

EC2: Frontend and backend instances.


# Infrastructure Architecture
![image](https://github.com/user-attachments/assets/b3710d2f-dbd9-499c-a915-bc7c2f64d5ab)

# Deployment Strategy
The project employs a branching strategy to manage environments efficiently:

# Branches:
dev: For development environments.

prod: For production environments.

feature-dev: For testing new features in the development environment.

feature-prod: For testing features before production release.

# Pipeline Workflow:
Pull: Jenkins fetches the Terraform code from the respective branch on GitHub.

Test: Runs terraform plan to validate infrastructure configurations.

Deploy: Executes terraform apply to provision or update resources

# Jenkins Setup and CI/CD Pipeline Implementation

This section outlines the steps to set up Jenkins and configure CI/CD pipelines for automating AWS infrastructure provisioning using Terraform.

# Setting up the Jenkins Server
Launch an EC2 Instance:

Instance Name: Jenkins Server.

Instance Type: t2.medium.

Storage: 20 GB.

AMI: Use a Linux-based AMI (e.g., Ubuntu or Amazon Linux).

Attach a security group allowing inbound traffic on port 8080 for Jenkins.


Connect to the EC2 Instance:

Use SSH to connect to the server:
```bash
ssh -i <key-pair>.pem ubuntu@<public-ip-address>
```

Install Jenkins:
Update the system and install dependencies:
```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version
```

Add Jenkins repository and install Jenkins:
```bash
Copy code
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins
```

Start Jenkins:
```bash
Copy code
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

Access Jenkins:
Open Jenkins in a browser using the instance's public IP and port 8080:
```bash
http://<public-ip>:8080
```

Retrieve the initial admin password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Complete the setup wizard and install recommended plugins.
```

 # Installing Required Tools
Install Terraform:
```bash
Copy code
sudo apt update
sudo apt install -y unzip
wget https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
unzip terraform_1.5.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

Install AWS CLI:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

Configure AWS CLI:
```bash
aws configure
Enter your AWS credentials, default region, and output format.
```

# Configuring Jenkins Pipelines
Set AWS Credentials in Jenkins:
Install Aws credentilas plugin in jenkins, AFter this follow below step
Go to Jenkins Dashboard > Manage Jenkins > Manage Credentials.

Add AWS credentials globally with:

ID: aws-creds.

Access Key and Secret Key.

# Set Up GitHub Webhook:

Navigate to your GitHub repository settings.

Add a webhook:

Payload URL: http://<jenkins-public-ip>:8080/github-webhook/.

Content Type: application/json.

Select Push Events.

# Create Jenkins Pipelines:

Create two pipelines (dev and prod) from the Jenkins dashboard.
Use the respective pipeline scripts provided below.

CI/CD Pipeline Scripts: this script automatically trrigred when you merge code dev-feature to dev branch

# Dev CI/CD Pipeline
```bash
pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    options {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']])
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/shubhamjain-tech/Aws-infra-terraform-jenkins.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh '''
                cd environments/dev
                terraform init
                '''
            }
        }
        stage('Terraform Plan') {
            steps {
                sh '''
                cd environments/dev
                terraform plan -out=tfplan
                '''
            }
        }
        stage('Terraform Apply') {
            steps {
                sh '''
                cd environments/dev
                terraform apply -auto-approve tfplan
                '''
            }
        }
    }
    post {
        success {
            echo 'Terraform resources created successfully!'
        }
        failure {
            echo 'Terraform execution failed. Check the logs.'
        }
    }
}
```

# Prod CI/CD Pipeline
```bash
pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    options {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']])
    }
    stages {
        stage('Checkout Code') {
            steps {
               git branch: 'prod', url: 'https://github.com/shubhamjain-tech/Aws-infra-terraform-jenkins.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh '''
                cd environments/prod
                terraform init
                '''
            }
        }
        stage('Terraform Plan') {
            steps {
                sh '''
                cd environments/prod
                terraform plan -out=tfplan
                '''
            }
        }
        stage('Terraform Apply') {
            steps {
                sh '''
                cd environments/prod
                terraform apply -auto-approve tfplan
                '''
            }
        }
    }
    post {
        success {
            echo 'Terraform resources created successfully for Prod ENV!'
        }
        failure {
            echo 'Terraform execution failed. Check the logs.'
        }
    }
}
```

# Testing the Pipelines
Push code to the dev or prod branch in the GitHub repository.

The respective Jenkins pipeline will be triggered automatically via the webhook.

Monitor the Jenkins console for pipeline execution logs.

# Destory Pipeline for dev-env

```bash
pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    options {
        // Makes credentials globally available in the pipeline
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']])
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/shubhamjain-tech/Aws-infra-terraform-jenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                cd environments/dev
                terraform init -backend-config="bucket=mybucket-backend-6721" \
                               -backend-config="key=dev/terraform.tfstate" \
                               -backend-config="region=ap-south-1" \
                               -backend-config="encrypt=true"
                '''
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh '''
                cd environments/dev
                terraform destroy -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo 'Terraform resources destroyed successfully!'
        }
        failure {
            echo 'Terraform destroy failed. Check the logs.'
        }
    }
}
```

# Destory pipeline for prod-env
```bash
pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    options {
        // Makes credentials globally available in the pipeline
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']])
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'prod', url: 'https://github.com/shubhamjain-tech/Aws-infra-terraform-jenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                cd environments/prod
                terraform init -backend-config="bucket=mybucket-backend-6721" \
                               -backend-config="key=prod/terraform.tfstate" \
                               -backend-config="region=ap-south-1" \
                               -backend-config="encrypt=true"
                '''
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh '''
                cd environments/prod
                terraform destroy -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo 'Terraform resources destroyed successfully Pod ENV!'
        }
        failure {
            echo 'Terraform destroy failed. Check the logs.'
        }
    }
}

```



