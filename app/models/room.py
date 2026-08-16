from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class Room(Base):
    __tablename__ = "rooms"

    id: Mapped[int] = mapped_column(
        primary_key=True,
        index=True
    )

    venue_id: Mapped[int] = mapped_column(
        ForeignKey("venues.id"),
        nullable=False
    )

    name: Mapped[str] = mapped_column(
        String(100)
    )

    room_type: Mapped[str] = mapped_column(
        String(50)
    )

    capacity: Mapped[int] = mapped_column(
        default=4
    )

    price: Mapped[float] = mapped_column(
        default=0
    )

    is_active: Mapped[bool] = mapped_column(
        default=True
    )