from sqlalchemy import ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class Venue(Base):
    __tablename__ = "venues"

    id: Mapped[int] = mapped_column(
        primary_key=True,
        index=True
    )

    business_id: Mapped[int] = mapped_column(
        ForeignKey("businesses.id"),
        nullable=False
    )

    name: Mapped[str] = mapped_column(
        String(150)
    )

    venue_type: Mapped[str] = mapped_column(
        String(50)
    )

    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    address: Mapped[str] = mapped_column(
        Text
    )

    city: Mapped[str] = mapped_column(
        String(100)
    )

    capacity: Mapped[int] = mapped_column(
        default=1
    )

    is_active: Mapped[bool] = mapped_column(
        default=True
    )