/*
Starter Static Web App module.
Note: Azure Static Web Apps usually are created via the portal or GitHub Action which can also create the resource.
This module creates a minimal Static Web App resource; you may prefer to create the Static Web App manually in the portal to get the API token.
*/

param location string
param staticWebAppName string
param repositoryUrl string = ''

resource staticApp 'Microsoft.Web/staticSites@2022-03-01' = {
  name: staticWebAppName
  location: location
  sku: {
    name: 'Free'
  }
  properties: {
    repositoryUrl: repositoryUrl
    // buildProperties and branch can be set by the GitHub Action during deploy
  }
}

output staticWebAppName string = staticApp.name
output staticWebAppResourceId string = staticApp.id
