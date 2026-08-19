from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.core.database import get_db
from app.models.venue import Venue
from app.schemas.venue import VenueCreate, VenueResponse


router = APIRouter(
    prefix="/venues",
    tags=["Venues"]
)


@router.post(
    "/",
    response_model=VenueResponse
)
async def create_venue(
    data: VenueCreate,
    db: AsyncSession = Depends(get_db)
):
    venue = Venue(**data.model_dump())

    db.add(venue)

    await db.commit()
    await db.refresh(venue)

    return venue


@router.get(
    "/",
    response_model=list[VenueResponse]
)
async def get_venues(
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(Venue)
    )

    return result.scalars().all()