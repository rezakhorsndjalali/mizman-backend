from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.core.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserResponse


router = APIRouter(
    prefix="/users",
    tags=["Users"]
)


@router.post(
    "/",
    response_model=UserResponse
)
async def create_user(
    data: UserCreate,
    db: AsyncSession = Depends(get_db)
):
    user = User(**data.model_dump())

    db.add(user)

    await db.commit()
    await db.refresh(user)

    return user


@router.get(
    "/",
    response_model=list[UserResponse]
)
async def get_users(
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(User)
    )

    return result.scalars().all()