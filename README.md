# Azure Infrastructure as Code (IaC) with Bicep  

This project automates the deployment of a **containerized Flask app** on Azure using **Bicep**, following security and operational best practices.

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
