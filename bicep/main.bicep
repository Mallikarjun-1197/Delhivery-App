/*
Starter main Bicep template for the project.
Creates a PostgreSQL Flexible Server, an App Service Plan + Function App, and a Static Web App module reference.
NOTE: These are starter templates and may need adjustments for your subscription/region and naming rules.
*/

@description('Location for all resources')
param location string = resourceGroup().location

@description('Project prefix used in resource names')
param projectPrefix string = 'delhivery'

@description('Admin username for Postgres')
param postgresAdmin string = 'pgadmin'

@secure()
@description('Admin password for Postgres (supply as parameter or by parameter file)')
param postgresAdminPassword string

@description('Postgres database name')
param postgresDbName string = 'delhiverydb'

@description('Name for the Static Web App')
param staticWebAppName string = '${projectPrefix}-static'

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

// Use Static Web App (with integrated Functions) instead of a separate Function App to keep costs low.
module staticApp './staticwebapp.bicep' = {
  name: 'staticModule'
  params: {
    location: location
    staticWebAppName: staticWebAppName
    repositoryUrl: 'https://github.com/Mallikarjun-1197/Delhivery-App'
  }
}

output postgresHost string = postgres.outputs.host
output staticWebAppName string = staticApp.outputs.staticWebAppName
