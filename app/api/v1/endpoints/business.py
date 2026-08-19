from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.core.database import get_db
from app.models.business import Business
from app.schemas.business import (
    BusinessCreate,
    BusinessResponse,
)


router = APIRouter(
    prefix="/businesses",
    tags=["Businesses"]
)


@router.post(
    "/",
    response_model=BusinessResponse
)
async def create_business(
    data: BusinessCreate,
    db: AsyncSession = Depends(get_db)
):
    business = Business(**data.model_dump())

    db.add(business)

    await db.commit()
    await db.refresh(business)

    return business


@router.get(
    "/",
    response_model=list[BusinessResponse]
)
async def get_businesses(
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(Business)
    )

    return result.scalars().all()