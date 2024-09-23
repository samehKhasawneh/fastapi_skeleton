from fastapi import APIRouter

from app.api.v1.endpoints import health

api_router = APIRouter()

# Include the health check router
api_router.include_router(health.router)

# Include other routers with prefixes
# api_router.include_router(auth_router, prefix="/auth", tags=["auth"])
