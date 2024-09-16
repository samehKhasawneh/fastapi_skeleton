from sqlalchemy.orm import Session

from app import crud, schemas
from app.core.config import settings
from app.db import base  # noqa: F401
from app.utils.csv_parser import parse_csv, get_csv_filenames_in_directory



# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28


def init_db(db: Session) -> None:
    # Tables should be created with Alembic migrations
    # But if you don't want to use migrations, create
    # the tables un-commenting the next line
    # Base.metadata.create_all(bind=engine)

    print('Creating superuser ...')
    user = crud.user.get_by_email(db, email=settings.FIRST_SUPERUSER)
    if not user:
        user_in = schemas.UserCreate(
            email=settings.FIRST_SUPERUSER,
            password=settings.FIRST_SUPERUSER_PASSWORD,
            is_superuser=True,
        )
        user = crud.user.create(db, obj_in=user_in)
    
    
    print('Creating system data ...')
    directory_path = "../initial_resources"
    csv_files = get_csv_filenames_in_directory(directory_path)

    for csv_file in csv_files:
        file_path = f"../initial_resources/{csv_file}"
        parsed_data = parse_csv(file_path)
        # print(file_path, parsed_data[0], '*************')

    #Foo.__table__.insert().execute([{'bar': 1}, {'bar': 2}, {'bar': 3}])
