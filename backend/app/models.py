from sqlmodel import SQLModel, Field, Relationship
from typing import List, Optional
from datetime import datetime

class Address(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: Optional[str]
    line1: str
    city: Optional[str]
    state: Optional[str]
    country: str
    postal_code: Optional[str]
    lat: Optional[float]
    lng: Optional[float]

class Shipment(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    pickup_address_id: Optional[int] = Field(default=None, foreign_key="address.id")
    delivery_address_id: Optional[int] = Field(default=None, foreign_key="address.id")
    contact_email: Optional[str]
    pickup_date: Optional[datetime]
    status: str = "pending"
    created_at: datetime = Field(default_factory=datetime.utcnow)
    packages: List['Package'] = Relationship(back_populates='shipment')
    tracking: List['TrackingEvent'] = Relationship(back_populates='shipment')

class Package(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    shipment_id: Optional[int] = Field(default=None, foreign_key="shipment.id")
    type: Optional[str]
    length: Optional[float]
    width: Optional[float]
    height: Optional[float]
    weight: Optional[float]
    value: Optional[float]
    shipment: Optional[Shipment] = Relationship(back_populates='packages')

class TrackingEvent(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    shipment_id: Optional[int] = Field(default=None, foreign_key="shipment.id")
    status: str
    message: Optional[str]
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    shipment: Optional[Shipment] = Relationship(back_populates='tracking')
