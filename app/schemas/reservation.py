from datetime import datetime

from pydantic import BaseModel, model_validator


class ReservationCreate(BaseModel):
    user_id: int
    venue_id: int

    table_id: int | None = None
    room_id: int | None = None

    start_time: datetime
    end_time: datetime

    guests: int

    @model_validator(mode="after")
    def validate_resource(self):
        if self.table_id is None and self.room_id is None:
            raise ValueError(
                "Either table_id or room_id is required"
            )

        if self.table_id is not None and self.room_id is not None:
            raise ValueError(
                "Only one resource can be reserved"
            )

        if self.end_time <= self.start_time:
            raise ValueError(
                "End time must be after start time"
            )

        if self.guests < 1:
            raise ValueError(
                "Guests must be at least 1"
            )

        return self


class ReservationResponse(ReservationCreate):
    id: int
    status: str

    model_config = {
        "from_attributes": True
    }