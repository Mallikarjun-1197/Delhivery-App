import azure.functions as func
from azure.functions import AsgiFunctionApp
from app.main import app

# Create the Azure Function App instance
# This wraps the FastAPI app and exposes it as a single HTTP function
app = func.AsgiFunctionApp(app=app, http_auth_level=func.AuthLevel.ANONYMOUS)
