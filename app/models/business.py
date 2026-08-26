from sqlalchemy import ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class Business(Base):
    __tablename__ = "businesses"

    id: Mapped[int] = mapped_column(
        primary_key=True,
        index=True
    )

    owner_id: Mapped[int] = mapped_column(
        ForeignKey("users.id"),
        nullable=False
    )

    name: Mapped[str] = mapped_column(
        String(150)
    )

    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    phone: Mapped[str | None] = mapped_column(
        String(20),
        nullable=True
    )

    is_verified: Mapped[bool] = mapped_column(
        default=False
    )

    is_active: Mapped[bool] = mapped_column(
        default=True
    )