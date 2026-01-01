/*
Main Bicep template for Delhivery App
- PostgreSQL Flexible Server
- Azure Function App (Consumption plan – lowest cost)
- Azure Static Web App (frontend only)
*/

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name for the Static Web App')
param staticWebAppName string = '${projectPrefix}-static'

@description('Project prefix used in resource names')
param projectPrefix string = 'delhivery'

@description('Admin username for Postgres')
param postgresAdmin string = 'pgadmin'

@secure()
@description('Admin password for Postgres')
param postgresAdminPassword string

@description('Postgres database name')
param postgresDbName string = 'delhiverydb'

@description('Name for the PostgreSQL server')
param postgresServerName string = '${projectPrefix}-pg-flex'

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
// PostgreSQL Flexible Server
// ==========================
resource postgres 'Microsoft.DBforPostgreSQL/flexibleServers@2025-08-01' = {
  name: postgresServerName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
    capacity: 1
    family: 'Gen5'
  }
  properties: {
    administratorLogin: postgresAdmin
    administratorLoginPassword: postgresAdminPassword
    version: '14'
    storage: {
      storageSizeGB: 32
    }
    highAvailability: {
      mode: 'Disabled'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    network: {
      publicNetworkAccess: 'Enabled'
    }
  }
}

// ==========================
// PostgreSQL Database
// ==========================
resource postgresDb 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2025-08-01' = {
  name: '${postgres.name}/${postgresDbName}' // <server>/<database>
  properties: {}
  dependsOn: [
    postgres
  ]
}


// ==========================
// Function App (Consumption Plan)
// ==========================
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    reserved: true
    httpsOnly: true
    siteConfig: {
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
          name: 'AzureWebJobsFeatureFlags'
          value: 'EnableWorkerIndexing'
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
    functionStorage
    postgres
    postgresDb
  ]
}

module staticApp './staticwebapp.bicep' = {
  name: 'staticModule'
  params: {
    location: location
    staticWebAppName: staticWebAppName
    repositoryUrl: 'https://github.com/Mallikarjun-1197/Delhivery-App'
  }
}
