from app.core import security
from app.core.config import settings
from app.core.db import engine
from sqlmodel import Session
from collections.abc import Generator

def get_db() -> Generator[Session, None, None]:
    with Session(engine) as session:
        yield session