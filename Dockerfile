# Use an official Flutter runtime as a parent image
FROM ghcr.io/cirruslabs/flutter:latest

# Create a non-root user
RUN useradd -ms /bin/bash user
USER user

# Set the working directory in the container
WORKDIR /home/user/app

# Copy the current directory contents into the container at /home/user/app
COPY . .

# Install any needed packages specified in pubspec.yaml
RUN flutter pub get

# Build the APK
RUN flutter build apk --release
