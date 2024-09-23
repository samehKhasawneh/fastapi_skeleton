from fastapi import APIRouter

router = APIRouter()

@router.get("/health", tags=["health"])
async def health_check():
    """
    Health check endpoint.
    Returns a JSON response indicating the service status.
    """
    return {"status": "ok"}