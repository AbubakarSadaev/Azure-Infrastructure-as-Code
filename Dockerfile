# Use the official Python image from Docker Hub as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define the environment variable FLASK_APP
ENV FLASK_APP=crudapp.py

# Run the Flask app on port 80
CMD ["flask", "run", "--host=0.0.0.0", "--port=80"]