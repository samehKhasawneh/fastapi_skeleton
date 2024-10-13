# from sqlalchemy import create_engine
# from sqlalchemy.orm import sessionmaker

# from app.core.config import settings

# engine = create_engine(settings.SQLALCHEMY_DATABASE_URI.unicode_string(), pool_pre_ping=True)
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

from app.core.config import settings

engine = create_async_engine(settings.SQLALCHEMY_DATABASE_URI.unicode_string())

SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False, class_=AsyncSession)
