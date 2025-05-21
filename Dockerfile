# Step 1: Use the official Dart image as the base image
FROM dart:stable AS build

# Step 2: Set working directory
WORKDIR /app

# Step 3: Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    curl \
    && apt-get clean

# Step 4: Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Step 5: Enable Flutter web support
RUN flutter channel stable \
    && flutter upgrade \
    && flutter config --enable-web

# Step 6: Copy the Flutter project files into the container
COPY . .

# Step 7: Get the Flutter dependencies
RUN flutter pub get

# Step 8: Build the Flutter web project
RUN flutter build web

# Step 9: Use Nginx to serve the built app
FROM nginx:alpine

# Step 10: Copy the build output to Nginx's html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Step 11: Expose the default HTTP port
EXPOSE 80

# Step 12: Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
