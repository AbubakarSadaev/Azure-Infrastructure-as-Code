﻿// Define parameters with their types and optional default values
param acrName string  // Name of the existing Azure Container Registry
param tokenName string = 'readonly-token'  // Name for the token 
param repositoryName string = 'hello'  // Name of the repository to grant access to
param tokenStatus string = 'enabled'  // Status of the token

// Reference an existing Azure Container Registry
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName  // Use the acrName parameter to identify the existing ACR
}

// Create a scope map that defines the permissions for the token
resource scopeMap 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-07-01' = {
  parent: acr  // This scope map belongs to the ACR referenced above
  name: '${tokenName}-scope'  // Scope map name derived from token name
  properties: {
    description: 'Read-only access to ${repositoryName} repository'  // Human-readable description
    actions: [  // List of permitted actions for this scope
      'repositories/${repositoryName}/content/read'  // Read repository content
      'repositories/${repositoryName}/metadata/read'  // Read repository metadata
    ]
  }
}

// Create a token that uses the scope map for authorization
resource token 'Microsoft.ContainerRegistry/registries/tokens@2023-07-01' = {
  parent: acr  // This token belongs to the ACR
  name: tokenName  // Use the tokenName parameter
  properties: {
    scopeMapId: scopeMap.id  // Reference the scope map created above
    status: tokenStatus  // Set token status (enabled/disabled)
  }
}

// Output values that can be used by other templates or scripts
output tokenName string = tokenName  // Returns the name of the created token
output tokenId string = token.id  // Returns the Azure resource ID of the token
