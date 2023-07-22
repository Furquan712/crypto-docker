# Stage 1: Build the React app
FROM node:14.17.6 as build

WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app's files
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Create a production-ready image
FROM nginx:1.21.1-alpine

# Set the working directory to the NGINX web root
WORKDIR /usr/share/nginx/html

# Remove default NGINX static files
RUN rm -rf ./*

# Copy the built React app from the previous stage
COPY --from=build /app/build .

# Expose port 80 (the default port for NGINX)
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
