# Stage 1: Build the dependencies
FROM python:3.12-slim-bullseye AS build

RUN pip install --upgrade pip

ENV POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LOG_LEVEL=DEBUG \
    ENVIRONMENT=local

RUN pip install poetry==1.8.3

WORKDIR /app/

COPY ./pyproject.toml ./poetry.lock* /app/
RUN touch README.md

RUN poetry install --no-root && rm -rf $POETRY_CACHE_DIR

# Stage 2: Create the production image
FROM python:3.12-slim-bullseye

ENV POETRY_NO_INTERACTION=1 \
    POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LOG_LEVEL=ERROR \
    ENVIRONMENT=production

RUN pip install poetry==1.8.3

WORKDIR /app/

COPY --from=build /app /app

RUN poetry install --without dev --no-root && rm -rf /tmp/poetry_cache

COPY ./app /app
ENV PYTHONPATH=/app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
