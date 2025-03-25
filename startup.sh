#!/bin/bash

# Collect static files
python manage.py collectstatic --noinput

# Apply database migrations
python manage.py migrate --noinput

# Start Gunicorn
gunicorn demoproject.wsgi:application --bind=0.0.0.0:8000

# Install dependencies
pip install -r requirements.txt 