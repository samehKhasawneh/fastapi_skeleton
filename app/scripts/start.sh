#!/bin/bash

####### /bin/bash start.sh

apply_migrations() {
    echo "Applying migrations..."
    (cd  '..' && alembic upgrade head)
}

downgrade_migrations() {
    echo "Downgrading migrations..."
    (cd  '..' && alembic downgrade -1)
}

generate_migrations() {
    if [ $# -eq 0 ]; then
        echo "No message provided for running the command."
    else
        message="$1"
        if [ -d "$message" ]; then
            echo "Generating migration $message..."
            (cd  '..' && alembic revision --autogenerate -m "$message")
        else
            echo "Something wrong with the message '$message'."
        fi
    fi
}


create_initial_data() {
    apply_migrations
    echo "Creating initial data: "
    (cd  '../app/utils' && python initial_data.py)
}

# Display menu
echo "Select an option:"
echo "1. Apply migrations"
echo "2. Generate migrations (with arguments)"
echo "3. Downgrading migrations"
echo "4. Create initial data"

# Read user input
read -p "Enter your choice (1-4): " choice

# Process user choice
case $choice in
    1)
        apply_migrations
        ;;
    2)
        read -p "Enter the migration message: " message
        generate_migrations "$message"
        ;;
    3)
        downgrade_migrations
        ;;
    4)
        create_initial_data
        ;;
    *)
        echo "Invalid choice. Please select a valid option '(1-4)'."
        ;;
esac
