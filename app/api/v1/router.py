from fastapi import APIRouter

from app.api.v1.endpoints import (
    users,
    business,
    venues,
    tables,
    rooms,
    reservations,
)


api_router = APIRouter()

api_router.include_router(users.router)
api_router.include_router(business.router)
api_router.include_router(venues.router)
api_router.include_router(tables.router)
api_router.include_router(rooms.router)
api_router.include_router(reservations.router)