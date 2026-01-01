import azure.functions as func
from azure.functions import AsgiMiddleware
from main import app  # Points to your FastAPI app

# Wrap FastAPI app for Azure Functions
asgi_handler = AsgiMiddleware(app)

async def main(req: func.HttpRequest, context: func.Context) -> func.HttpResponse:
    return await asgi_handler.handle_async(req, context)
