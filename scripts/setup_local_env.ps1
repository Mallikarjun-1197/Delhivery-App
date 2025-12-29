# PowerShell helper to set up local Python env for backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r backend/requirements.txt
Write-Host "Backend virtual env created and dependencies installed. Run: python backend/run.py"