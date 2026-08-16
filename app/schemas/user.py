from pydantic import BaseModel


class UserCreate(BaseModel):
    full_name: str
    phone: str
    email: str | None = None
    role: str = "customer"


class UserResponse(BaseModel):
    id: int
    full_name: str
    phone: str
    email: str | None
    role: str
    is_active: bool

    model_config = {
        "from_attributes": True
    }