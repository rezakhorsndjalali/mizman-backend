from pydantic import BaseModel


class VenueCreate(BaseModel):
    business_id: int
    name: str
    venue_type: str
    description: str | None = None
    address: str
    city: str
    capacity: int


class VenueResponse(VenueCreate):
    id: int
    is_active: bool

    model_config = {
        "from_attributes": True
    }