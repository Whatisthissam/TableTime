# ==============================================================================
# Stage 1: Build Flutter Web Application
# ==============================================================================
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy pubspec files first for layer caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy all project source code
COPY . .

# Build production optimized Flutter web application with CanvasKit / HTML renderer
RUN flutter build web --release

# ==============================================================================
# Stage 2: Serve Web Assets via High-Performance Nginx Alpine
# ==============================================================================
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built Flutter web bundle from build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration for SPA routing & caching
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Render dynamically sets PORT environment variable (default: 80 or 10000)
ENV PORT=80
EXPOSE 80 10000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
