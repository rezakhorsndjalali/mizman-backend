from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.core.database import get_db
from app.models.table import Table
from app.schemas.table import TableCreate, TableResponse


router = APIRouter(
    prefix="/tables",
    tags=["Tables"]
)


@router.post(
    "/",
    response_model=TableResponse
)
async def create_table(
    data: TableCreate,
    db: AsyncSession = Depends(get_db)
):
    table = Table(**data.model_dump())

    db.add(table)

    await db.commit()
    await db.refresh(table)

    return table


@router.get(
    "/",
    response_model=list[TableResponse]
)
async def get_tables(
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(Table)
    )

    return result.scalars().all()