FROM python:3.12-slim-bullseye

# Upgrade pip and install necessary dependencies for Poetry
RUN pip install --upgrade pip

# Install the latest stable version of Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Set environment variables for Poetry
ENV POETRY_NO_INTERACTION=1 \
    POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="$POETRY_HOME/bin:$PATH"

WORKDIR /app/

# Copy pyproject.toml and poetry.lock (if exists) to the working directory
COPY ./app/pyproject.toml ./app/poetry.lock* /app/
RUN touch README.md

# Install project dependencies without dev dependencies
RUN poetry install --without dev --no-root && rm -rf $POETRY_CACHE_DIR

# Copy the rest of the application code
COPY ./app /app
ENV PYTHONPATH=/app
