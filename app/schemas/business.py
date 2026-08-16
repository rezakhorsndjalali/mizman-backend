from pydantic import BaseModel


class BusinessCreate(BaseModel):
    owner_id: int
    name: str
    description: str | None = None
    phone: str | None = None


class BusinessResponse(BusinessCreate):
    id: int
    is_verified: bool
    is_active: bool

    model_config = {
        "from_attributes": True
    }