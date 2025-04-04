// Define the location for the resources, defaulting to the resource group's location
param location string = resourceGroup().location

// Define the Azure Container Registry (ACR) name
param acrName string = 'asuniquename'

// Define the container image to be deployed
param containerImage string = 'hello:latest'

// Define the name of the container instance
param containerName string = 'hello-app'

// Define resource limits for the container
param cpuCores int = 1
param memoryInGB int = 1

// Define credentials for accessing the ACR
param acrUsername string
@secure()
param acrPassword string

// 1. LOG ANALYTICS WORKSPACE
// Creates a Log Analytics workspace for monitoring container logs
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'aci-logs-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30  // Retain logs for 30 days
  }
}

// 4. CONTAINER GROUP
// Deploys a container instance in Azure Container Instances (ACI)
resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: containerName
  location: location
  properties: {
    containers: [{
      name: containerName
      properties: {
        image: '${acrName}.azurecr.io/${containerImage}' // Pulls the image from ACR
        resources: {
          requests: {
            cpu: cpuCores
            memoryInGB: memoryInGB
          }
        }
        ports: [{ port: 80 }] // Exposes port 80 for HTTP traffic
      }
    }]
    imageRegistryCredentials: [{
      server: '${acrName}.azurecr.io'
      username: acrUsername
      password: acrPassword
    }]
    osType: 'Linux' // Specifies Linux as the operating system
    ipAddress: {
      type: 'Public'
      ports: [{ protocol: 'TCP', port: 80 }]
      dnsNameLabel: '${containerName}-${uniqueString(resourceGroup().id)}' // Generates a unique DNS name
    }
    diagnostics: {
      logAnalytics: {
        workspaceId: workspace.properties.customerId
        workspaceKey: workspace.listKeys().primarySharedKey
        logType: 'ContainerInsights' // Enables container monitoring
      }
    }
  }
}

// Outputs
// Outputs the public URL of the deployed container
output applicationUrl string = 'http://${containerGroup.properties.ipAddress.fqdn}'

// Outputs the name of the Log Analytics workspace
output logAnalyticsWorkspace string = workspace.name
