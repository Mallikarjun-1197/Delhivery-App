# DelhiveryApp (scaffold)

This repository is a scaffold for an international courier booking app (MVP).

Stack (MVP):
- Frontend: React + Vite + TypeScript + Tailwind
- Backend: FastAPI (Python) with SQLModel + SQLite for local dev
- Deployment target: Azure Static Web Apps (frontend) + Azure Functions (Python) for API

What's included:
- Frontend skeleton with Create Shipment form and tracking page
- Backend FastAPI app with basic endpoints and SQLModel models
- GitHub Actions workflow templates (placeholders)
- Local dev instructions

Next steps:
- Confirm Google Maps integration keys and add in frontend
- Configure Postgres on Azure for production and update DATABASE_URL
- Add IaC (Bicep/Terraform) and GitHub Actions secrets for deployment

Deployment (GitHub Actions):
- Frontend: Azure Static Web Apps. Workflow is in `.github/workflows/frontend-deploy.yml` and expects the secret `AZURE_STATIC_WEB_APPS_API_TOKEN` (obtain from the Static Web App resource in Azure).
- Backend: Azure Functions. Workflow is in `.github/workflows/backend-deploy.yml` and can use either:
  - A service principal stored in `AZURE_CREDENTIALS` (create via `az ad sp create-for-rbac --sdk-auth`), or
  - A publish profile stored in `FUNCTIONS_PUBLISH_PROFILE` (get from Function App -> Get publish profile).
- Also set `AZURE_FUNCTION_APP_NAME` (the name of the Function App) and (later) `DATABASE_URL` for production Postgres.

New: Infra deployment workflow
- `infra-deploy.yml` (in `.github/workflows`) runs our Bicep template to create Postgres, Function App, and Static Web App resources. It requires these secrets:
  - `AZURE_CREDENTIALS` — service principal JSON from `az ad sp create-for-rbac --sdk-auth` (recommended).
  - `POSTGRES_ADMIN_PASSWORD` — admin password for PostgreSQL (or use KeyVault integration in the Bicep parameter file).

Quick steps to create necessary Azure credentials and secrets:
1. Login to Azure locally:
   - az login
2. Create resource group (optional; the workflow can create it):
   - az group create -n delhivery-rg -l eastus2
3. Create a service principal (recommended for CI):
   - az ad sp create-for-rbac --name "delhivery-sp" --role contributor --scopes /subscriptions/<SUB_ID>/resourceGroups/delhivery-rg --sdk-auth
   - Copy the JSON output and add it to the repo secret `AZURE_CREDENTIALS` (in GitHub: Settings → Secrets → Actions).
4. Add `POSTGRES_ADMIN_PASSWORD` as a repo secret or store in KeyVault and reference it in `main.parameters.json`.
5. If you prefer publish-profile for Functions, get it from Function App → Get publish profile and add it as `FUNCTIONS_PUBLISH_PROFILE`.

How to run the infra deploy workflow:
- From the GitHub UI: Actions → Infra Deploy (Bicep) → Run workflow (select or confirm `resource_group` and `location`).
- Or push to `main` (workflow will run on push). 

To run locally (frontend):
- cd frontend
- npm install
- npm run dev

To run locally (backend):
- python -m venv .venv
- .\.venv\Scripts\Activate.ps1
- pip install -r backend/requirements.txt
- python backend/run.py

To create a GitHub repo and push, either provide a GitHub PAT or authenticate with the GitHub CLI (`gh auth login`) and I can create the remote and push for you.
