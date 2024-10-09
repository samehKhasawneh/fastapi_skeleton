from contextlib import asynccontextmanager

from fastapi import FastAPI, APIRouter
from starlette.middleware.cors import CORSMiddleware

from app.api.v1.api import api_router
from app.core.config import settings
from app.core.logging import logger


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup actions (if any)
    logger.info("Server started!")
    yield
    # Shutdown actions
    logger.info("Server shutdown!")
    # await function_call()

app = FastAPI(
    title=settings.PROJECT_NAME, 
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

health_router = APIRouter()

@health_router.get("/health")
async def health_check():
    """
    Health check endpoint.
    Returns a JSON response indicating the service status.
    """
    return {"status": "ok"}

app.include_router(health_router)
app.include_router(api_router, prefix=settings.API_V1_STR)
