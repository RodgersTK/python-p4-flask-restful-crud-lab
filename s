#!/bin/bash

# Step 2: Set the FLASK_APP environment variable
export FLASK_APP=server/app.py
echo "Set FLASK_APP to $FLASK_APP"

# Step 3: Initialize the database
echo "Initializing the database..."
flask db init

if [ $? -ne 0 ]; then
    echo "Failed to initialize the database."
    exit 1
fi

# Step 4: Create a migration script
echo "Creating migration script..."
flask db migrate

if [ $? -ne 0 ]; then
    echo "Failed to create migration."
    exit 1
fi

# Step 5: Apply the migration
echo "Applying the migration..."
flask db upgrade head

if [ $? -ne 0 ]; then
    echo "Failed to apply migration."
    exit 1
fi

# Step 6: Seed the database
echo "Seeding the database..."
python server/seed.py

if [ $? -ne 0 ]; then
    echo "Failed to seed the database."
    exit 1
fi

# Step 7: Run tests
echo "Running tests..."
pytest

if [ $? -ne 0 ]; then
    echo "Tests failed."
    exit 1
fi

echo "All steps completed successfully."
