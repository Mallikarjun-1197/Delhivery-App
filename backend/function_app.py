import azure.functions as func
from azure.functions import AsgiFunctionApp
from app.main import app as fastapi_app

# Wrap FastAPI app in Azure Functions ASGI host
app = AsgiFunctionApp(
    app=fastapi_app,
    http_auth_level=func.AuthLevel.ANONYMOUS
)
