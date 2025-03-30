param location string = resourceGroup().location
param acrName string = 'asuniquename'
param containerImage string = 'hello:latest'
param containerName string = 'hello-app'
param cpuCores int = 1
param memoryInGB int = 1
param acrUsername string
@secure()
param acrPassword string

// 1. LOG ANALYTICS WORKSPACE
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'aci-logs-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30
  }
}

// 4. CONTAINER GROUP
resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: containerName
  location: location
  properties: {
    containers: [{
      name: containerName
      properties: {
        image: '${acrName}.azurecr.io/${containerImage}'
        resources: {
          requests: {
            cpu: cpuCores
            memoryInGB: memoryInGB
          }
        }
        ports: [{ port: 80 }]
      }
    }]
    imageRegistryCredentials: [{
      server: '${acrName}.azurecr.io'
      username: acrUsername
      password: acrPassword
    }]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [{ protocol: 'TCP', port: 80 }]
      dnsNameLabel: '${containerName}-${uniqueString(resourceGroup().id)}'
    }
    diagnostics: {
      logAnalytics: {
        workspaceId: workspace.properties.customerId
        workspaceKey: workspace.listKeys().primarySharedKey
        logType: 'ContainerInsights'
      }
    }
  }
}

// Outputs
output applicationUrl string = 'http://${containerGroup.properties.ipAddress.fqdn}'
output logAnalyticsWorkspace string = workspace.name