from pydantic import BaseModel


class TableCreate(BaseModel):
    venue_id: int
    name: str
    capacity: int
    price: float = 0


class TableResponse(TableCreate):
    id: int
    is_active: bool

    model_config = {
        "from_attributes": True
    }