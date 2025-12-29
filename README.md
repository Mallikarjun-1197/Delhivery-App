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
