from fastapi import FastAPI, HTTPException, Depends
from sqlmodel import select
from typing import List
from .models import Shipment, Package, Address, TrackingEvent
from .database import init_db, get_session

app = FastAPI(title="DelhiveryApp API")

@app.on_event("startup")
def on_startup():
    init_db()

@app.post('/api/shipments', response_model=dict)
def create_shipment(payload: dict):
    # Basic stub: In a real app validate payload and persist to DB
    # For now return a fake booking id
    return {"booking_id": "BK-" + str(1000)}

@app.get('/api/shipments/{shipment_id}')
def get_shipment(shipment_id: int):
    # stub
    return {"id": shipment_id, "status": "pending"}

@app.get('/api/shipments')
def list_shipments(status: str = None):
    return [{"id": 1, "status": status or 'pending'}]

@app.post('/api/shipments/{shipment_id}/tracking')
def add_tracking(shipment_id: int, payload: dict):
    return {"ok": True}

@app.get('/api/track/{tracking_id}')
def public_track(tracking_id: str):
    return {"tracking_id": tracking_id, "status": "Info not yet available"}
