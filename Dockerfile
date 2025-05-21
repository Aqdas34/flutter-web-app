# Use a Flutter image with web support preinstalled
FROM cirrusci/flutter:stable-web AS build

WORKDIR /app

# Copy your entire Flutter project into the container
COPY . .

# Get dependencies
RUN flutter pub get

# Build the web app
RUN flutter build web

# Use a lightweight nginx image to serve the app
FROM nginx:alpine

# Copy the build output to nginx's serving directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
