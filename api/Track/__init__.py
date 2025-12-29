import logging
import azure.functions as func
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Track function processed a request.')
    tracking_id = req.route_params.get('id') or req.params.get('id')
    status = {"tracking_id": tracking_id, "status": "unknown", "history": []}
    return func.HttpResponse(json.dumps(status), mimetype='application/json')
