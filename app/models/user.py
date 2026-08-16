from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(
        primary_key=True,
        index=True
    )

    full_name: Mapped[str] = mapped_column(
        String(100)
    )

    phone: Mapped[str] = mapped_column(
        String(20),
        unique=True,
        index=True
    )

    email: Mapped[str | None] = mapped_column(
        String(150),
        unique=True,
        nullable=True
    )

    role: Mapped[str] = mapped_column(
        String(30),
        default="customer"
    )

    is_active: Mapped[bool] = mapped_column(
        default=True
    )