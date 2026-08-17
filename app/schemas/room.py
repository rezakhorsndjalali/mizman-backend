from pydantic import BaseModel


class RoomCreate(BaseModel):
    venue_id: int
    name: str
    room_type: str
    capacity: int
    price: float = 0


class RoomResponse(RoomCreate):
    id: int
    is_active: bool

    model_config = {
        "from_attributes": True
    }