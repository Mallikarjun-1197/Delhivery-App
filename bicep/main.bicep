/*
Main Bicep template for Delhivery App
- PostgreSQL Flexible Server
- Azure Function App (Consumption plan – lowest cost)
- Azure Static Web App (frontend only)
*/

@description('Location for all resources')
param location string = resourceGroup().location

@description('Project prefix used in resource names')
param projectPrefix string = 'delhivery'

@description('Admin username for Postgres')
param postgresAdmin string = 'pgadmin'

@secure()
@description('Admin password for Postgres')
param postgresAdminPassword string

@description('Postgres database name')
param postgresDbName string = 'delhiverydb'

@description('Name for the Static Web App')
param staticWebAppName string = '${projectPrefix}-static'

@description('Name for the Azure Function App')
param functionAppName string = '${projectPrefix}-api-func'

/* -------------------------
   PostgreSQL (existing)
--------------------------*/
module postgres './postgres.bicep' = {
  name: 'postgresModule'
  params: {
    location: location
    serverName: '${projectPrefix}-pg'
    adminUser: postgresAdmin
    adminPassword: postgresAdminPassword
    dbName: postgresDbName
  }
}

/* -------------------------
   Function App (CHEAPEST)
--------------------------*/

/* Storage Account (required by Functions) */

var storageAccountName = toLower(
  replace('${projectPrefix}${uniqueString(resourceGroup().id)}', '-', '')
)

resource functionStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

/* Consumption Plan (Y1 = ₹0 when idle) */
resource functionPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${functionAppName}-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

/* Azure Function App (Python 3.11) */
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: functionPlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'Python|3.11'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: functionStorage.properties.primaryEndpoints.blob
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'POSTGRES_HOST'
          value: postgres.outputs.host
        }
        {
          name: 'POSTGRES_DB'
          value: postgresDbName
        }
        {
          name: 'POSTGRES_USER'
          value: postgresAdmin
        }
      ]
    }
  }
}

/* -------------------------
   Static Web App (frontend only)
--------------------------*/
module staticApp './staticwebapp.bicep' = {
  name: 'staticModule'
  params: {
    location: location
    staticWebAppName: staticWebAppName
    repositoryUrl: 'https://github.com/Mallikarjun-1197/Delhivery-App'
  }
}

/* -------------------------
   Outputs
--------------------------*/
output postgresHost string = postgres.outputs.host
output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}/api'
output staticWebAppName string = staticApp.outputs.staticWebAppName
