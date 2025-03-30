🚀 Azure Infrastructure as Code (IaC) with Bicep
This project demonstrates Infrastructure as Code (IaC) using Bicep to deploy a containerized Flask application on Azure with security and monitoring best practices.

📋 Overview
The project automates the deployment of:

Azure Container Registry (ACR) – Stores the Docker container image.

ACR Token with Least Privilege – Secures access to the registry.

Azure Container Instance (ACI) – Runs the Flask app with public access.

✅ Best Practices Implemented
Public IP – Allows external access to the application.

HTTP on Port 80 – Standard web traffic port.

Azure Monitor Logging – Centralized logging for container diagnostics.

Least Privilege ACR Token – Restricts access to only necessary permissions.

📂 Files
File	Description
main.bicep	Creates an Azure Container Registry (ACR) with security best practices.
acr-token.bicep	Generates a least-privilege ACR token for secure access.
aci-deployment.bicep	Deploys the container to Azure Container Instances (ACI) with a public IP and logging.
