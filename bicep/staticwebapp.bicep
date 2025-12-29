/*
Starter Static Web App module.
Note: Azure Static Web Apps usually are created via the portal or GitHub Action which can also create the resource.
This module creates a minimal Static Web App resource; you may prefer to create the Static Web App manually in the portal to get the API token.
*/

param location string
param staticWebAppName string

resource staticApp 'Microsoft.Web/staticSites@2022-03-01' = {
  name: staticWebAppName
  location: location
  properties: {
    sku: {
      name: 'Free'
      tier: 'Free'
    }
  }
}

output staticWebAppName string = staticApp.name
output staticWebAppResourceId string = staticApp.id
