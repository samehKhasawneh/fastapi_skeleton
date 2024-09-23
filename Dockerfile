FROM python:3.12-slim-bullseye

# Upgrade pip and install necessary dependencies for Poetry
RUN pip install --upgrade pip

# Set environment variables for Poetry
ENV POETRY_NO_INTERACTION=1 \
    POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install poetry
RUN pip install poetry==1.8.3

WORKDIR /app/

# Copy pyproject.toml and poetry.lock (if exists) to the working directory
COPY ./pyproject.toml ./poetry.lock* /app/
RUN touch README.md

# Install project dependencies without dev dependencies
RUN poetry install --without dev --no-root && rm -rf $POETRY_CACHE_DIR

# Copy the rest of the application code
COPY ./app /app
ENV PYTHONPATH=/app
