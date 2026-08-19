from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.core.database import get_db
from app.models.room import Room
from app.schemas.room import RoomCreate, RoomResponse


router = APIRouter(
    prefix="/rooms",
    tags=["Rooms"]
)


@router.post(
    "/",
    response_model=RoomResponse
)
async def create_room(
    data: RoomCreate,
    db: AsyncSession = Depends(get_db)
):
    room = Room(**data.model_dump())

    db.add(room)

    await db.commit()
    await db.refresh(room)

    return room


@router.get(
    "/",
    response_model=list[RoomResponse]
)
async def get_rooms(
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(Room)
    )

    return result.scalars().all()