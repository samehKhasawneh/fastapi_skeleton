from fastapi import APIRouter

from app.api.v1.endpoints.health import router as health_router

api_router = APIRouter()

# Include the health check router
api_router.include_router(health_router)

# Include other routers with prefixes
# api_router.include_router(auth_router, prefix="/auth", tags=["auth"])
