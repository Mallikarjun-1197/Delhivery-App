# Bicep templates (starter)

This folder contains starter Bicep templates for provisioning resources on Azure for Delhivery-App.

Included:
- `main.bicep` - orchestrates modules for Postgres, Function App, and Static Web App
- `postgres.bicep` - starter PostgreSQL Flexible Server
- `functionapp.bicep` - starter Function App + Storage + Plan
- `staticwebapp.bicep` - minimal Static Web App resource (you may prefer to create via portal or GH Action)
- `main.parameters.json` - example parameter file

Quick deploy (example):
1. Create resource group:
   az group create -n delhivery-rg -l eastus

2. Deploy the Bicep template (supply secure password as parameter or via KeyVault reference):
   az deployment group create --resource-group delhivery-rg --template-file bicep/main.bicep --parameters postgresAdminPassword="<YOUR_PASSWORD>" staticWebAppName="delhivery-static" functionAppName="delhivery-func" location="eastus"

Notes & next actions:
- These templates are starter examples and may require adjustments (networking, sku sizes, firewall rules, backups, private endpoint, high availability) before production use.
- For production Postgres, set up geo-redundancy, backups, and firewall rules. Consider enabling private endpoints and restricting access.
- Azure Static Web Apps are often created via the GitHub Action which can automatically populate the deployment token. You can either create the resource via portal (then add token to repo secrets) or manage it via the GH Action.
- I can extend these templates to add KeyVault, App Insights, private networking, and GitHub Actions integration if you want.
