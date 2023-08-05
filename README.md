# Terraform Script to Deploy WordPress Application in AWS
This Terraform code is designed to create an Amazon Virtual Private Cloud (VPC) along with associated subnets for an EC2 instance and an RDS database. Additionally, it provisions security groups for both resources and an Elastic IP for the EC2 instance. The EC2 instance is configured to run a WordPress container using PHP-FPM, and the RDS instance is set up as a MySQL database. Below are the steps to use this code.

# Requirements
Before running the Terraform code, make sure you have the following prerequisites:

1. An AWS account with appropriate IAM credentials.
2. Terraform installed on your local machine. You can download it from the official website: https://www.terraform.io/downloads.html
3. An ARM-based Amazon Machine Image (AMI) ID for the EC2 instance. You can find the appropriate AMI ID in your AWS EC2 console or the AWS CLI.

# Deployment Steps
1. Clone the repository containing the Terraform configuration files using the following command:
   **git clone <repository_url>**
2. Navigate to the directory where the files are located using the terminal or command prompt:
   **cd <repository_directory>**
3. Open the variables.tf file and customize the variables as needed. Modify the following variables to suit your requirements:
   - ami: The ARM-based AMI ID for the EC2 instance.
   - instance_type: The EC2 instance type you want to use (e.g., t2.micro, t3.small, etc.).
   - db_password: The password for the RDS database.
   - You can also modify other variables such as vpc_cidr_block, ec2_subnet_cidr_block, etc., if required.
4. Initialize the Terraform configuration:
   **terraform init**
5. Review the resources that will be created and check for any errors:
   **terraform plan**
6. Apply the Terraform configuration to create the VPC, subnets, security groups, EC2 instance, RDS instance, and Elastic IP:
   **terraform apply**
   Enter "yes" when prompted to confirm the resource creation.
7. Once the deployment is complete, Terraform will display the outputs, including the public IP address of the EC2 instance.
8. Access the WordPress application running on the EC2 instance by using the public IP address shown in the Terraform output. You can access it through a web browser.

# Resources Created
   The Terraform script will create the following AWS resources:

1. VPC: A new VPC with a CIDR block of 10.0.0.0/16.
2. EC2 Subnet: A subnet with CIDR block 10.0.1.0/24 for the EC2 instance.
3. RDS Subnet: A subnet with CIDR block 10.0.2.0/24 for the RDS instance.
4. EC2 Security Group: A security group for the EC2 instance allowing SSH access from any IP address.
5. RDS Security Group: A security group for the RDS instance allowing MySQL connections from the EC2 security group.
6. Elastic IP: An Elastic IP for the EC2 instance to provide a static public IP address.
7. EC2 Instance: An EC2 instance launched using the specified AMI and instance type, with the latest WordPress container running on it.
8. RDS Instance: An RDS instance with MySQL engine and the provided configurations.

# Important Notes
1. The code assumes that you have a valid ARM-based AMI ID available in the ami variable for the EC2 instance.
2. Ensure you replace /path/to/wordpress in the EC2 instance's user data script with the actual path to your WordPress files.
3. Customize the variables in the variables.tf file according to your requirements.
4. Be cautious with the database credentials and avoid hardcoding sensitive information.
5. The RDS instance is set as not publicly accessible (publicly_accessible = false) for security reasons. Only the EC2 instance within the VPC can access it.
6. You may need to adapt other configurations (e.g., backup, monitoring, multi-AZ setup) based on your specific needs.

# Cleanup
To tear down the resources and avoid incurring unnecessary costs, use the following command after you are done testing:
**terraform destroy**

Please note that this will destroy all resources created by Terraform for this VPC, EC2 instance, and RDS instance.

# Disclaimer
Use this Terraform code at your own risk. Ensure that you understand the AWS resources being created and their associated costs. It's recommended to review the Terraform code and consult the official AWS documentation before running it in a production environment

