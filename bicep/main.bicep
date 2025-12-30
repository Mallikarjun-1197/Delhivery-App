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

// ==========================
// Storage Account
// ==========================
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
  properties: {}
}


// ==========================
// PostgreSQL Server
// ==========================
resource postgres 'Microsoft.DBforPostgreSQL/servers@2022-12-01' = {
  name: 'postgresModule'
  location: location
  sku: {
    name: 'B_Gen5_1'
    tier: 'Basic'
    capacity: 1
    family: 'Gen5'
  }
  properties: {
    administratorLogin: postgresAdmin
    administratorLoginPassword: postgresAdminPassword
    version: '14'
    sslEnforcement: 'Enabled'
    storageProfile: {
      storageMB: 5120
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
  }
}

// ==========================
// PostgreSQL Database
// ==========================
resource postgresDb 'Microsoft.DBforPostgreSQL/servers/databases@2022-12-01' = {
  parent: postgres
  name: postgresDbName
  properties: {}
}

// ==========================
// Function App
// ==========================
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'Python|3.11'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorage.name};AccountKey=${functionStorage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'POSTGRES_HOST'
          value: postgres.properties.fullyQualifiedDomainName
        }
        {
          name: 'POSTGRES_DB'
          value: postgresDbName
        }
        {
          name: 'POSTGRES_USER'
          value: postgresAdmin
        }
        {
          name: 'POSTGRES_PASSWORD'
          value: postgresAdminPassword
        }
      ]
    }
  }
  dependsOn: [
    functionPlan
    functionStorage
    postgres
    postgresDb
  ]
}
