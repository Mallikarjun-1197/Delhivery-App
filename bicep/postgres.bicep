/*
Simple PostgreSQL Flexible Server module (starter)
This uses Flexible Server - adjust sku/zone/redundancy for your needs.
*/

param location string
param serverName string
param adminUser string
@secure()
param adminPassword string
param dbName string = 'db'

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: serverName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: adminUser
    administratorLoginPassword: adminPassword
    version: '13'
    storage: {
      storageSizeGB: 32
    }
  }
}

resource postgresDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: '${postgresServer.name}/${dbName}'
  properties: {}
}

output host string = '${postgresServer.name}.postgres.database.azure.com'
output databaseName string = dbName
output serverName string = postgresServer.name
