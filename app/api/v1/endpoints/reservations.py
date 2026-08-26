from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.models.reservation import Reservation
from app.schemas.reservation import (
    ReservationCreate,
    ReservationResponse,
)


router = APIRouter(
    prefix="/reservations",
    tags=["Reservations"]
)


@router.post(
    "/",
    response_model=ReservationResponse
)
async def create_reservation(
    data: ReservationCreate,
    db: AsyncSession = Depends(get_db)
):
    query = select(Reservation).where(
        Reservation.venue_id == data.venue_id,
        Reservation.status.in_(
            ["pending", "confirmed"]
        ),
        Reservation.start_time < data.end_time,
        Reservation.end_time > data.start_time,
    )

    if data.table_id:
        query = query.where(
            Reservation.table_id == data.table_id
        )

    if data.room_id:
        query = query.where(
            Reservation.room_id == data.room_id
        )

    result = await db.execute(query)

    existing_reservation = result.scalar_one_or_none()

    if existing_reservation:
        raise HTTPException(
            status_code=409,
            detail="The selected resource is already reserved."
        )

    reservation = Reservation(
        **data.model_dump(),
        status="confirmed"
    )

    db.add(reservation)

    await db.commit()
    await db.refresh(reservation)

    return reservation


@router.get(
    "/",
    response_model=list[ReservationResponse]
)
async def get_reservations(
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(Reservation)
    )

    return result.scalars().all()A  A       