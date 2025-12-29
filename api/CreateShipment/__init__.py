import logging
import azure.functions as func
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('CreateShipment function processed a request.')
    try:
        data = req.get_json()
    except ValueError:
        data = {}

    # Minimal stub: echo back and return a booking id
    booking_id = "BK-" + str(1000)
    response = {"booking_id": booking_id, "received": data}
    return func.HttpResponse(json.dumps(response), mimetype="application/json")
