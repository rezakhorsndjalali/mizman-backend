from datetime import datetime

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class Reservation(Base):
    __tablename__ = "reservations"

    id: Mapped[int] = mapped_column(
        primary_key=True,
        index=True
    )

    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.id"),
        nullable=False
    )

    venue_id: Mapped[int] = mapped_column(
        ForeignKey("venues.id"),
        nullable=False
    )

    table_id: Mapped[int | None] = mapped_column(
        ForeignKey("tables.id"),
        nullable=True
    )

    room_id: Mapped[int | None] = mapped_column(
        ForeignKey("rooms.id"),
        nullable=True
    )

    start_time: Mapped[datetime] = mapped_column()

    end_time: Mapped[datetime] = mapped_column()

    guests: Mapped[int] = mapped_column(
        default=1
    )

    status: Mapped[str] = mapped_column(
        String(30),
        default="pending"
    )