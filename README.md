# Azure Infrastructure as Code (IaC) with Bicep  

This project deploys a **CRUD app** on Azure using **Bicep**, following security and operational best practices.

## 📋 Overview  
### Key Components  
1. **Azure Container Registry (ACR)** - Stores the Docker container image securely.  
2. **Least-Privilege ACR Token** - Restricts access to only necessary repository permissions.  
3. **Azure Container Instance (ACI)** - Runs the app with public accessibility.  

### ✅ Implemented Best Practices  
- **Public IP** for external access  
- **HTTP/80** for standard web traffic  
- **Azure Monitor Logging** for centralized diagnostics  
---

## 📂 File Structure  
| File | Purpose |  
|------|---------|  
| [`main.bicep`](./main.bicep) | Creates the Azure Container Registry |  
| [`acr-token.bicep`](./acr-token.bicep) | Generates scoped ACR access token |  
| [`aci-deployment.bicep`](./aci-deployment.bicep) | Deploys container to ACI with monitoring |  

---
## 🛠️ Deployment   
```bash
docker build -t <your-image-name> .
az login

# Deploy ACR
az deployment group create `
  --resource-group <your-rg> `
  --template-file main.bicep

# Create ACR token
az deployment group create `
  --resource-group <your-rg> `
  --template-file acr-token.bicep

# Launch container
az deployment group create `
  --resource-group <your-resource-group> `
  --template-file aci-deployment.bicep `
  --parameters `
    acrName=<your-acr-name> `
    containerImage=<your-image-name>:latest `
    acrUsername=<your-acr-username> `
    acrPassword='<your-acr-password>'

# Access the app
az container show `
  --name <your-aci-name> `
  --resource-group <your-resource-group> `
  --query "ipAddress.fqdn" `
  --output tsv!

Azure Monitor:
![image](https://github.com/user-attachments/assets/88d948eb-c175-4509-8320-4932eb284bf5)

App:
![image](https://github.com/user-attachments/assets/55b75e7b-5b2a-402c-9aed-17668f1e6e8e)


