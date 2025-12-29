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
