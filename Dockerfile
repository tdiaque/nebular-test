# build environment
###FROM node:latest as build
###
###WORKDIR /app
###COPY . .
###
###RUN npm ci
###
###RUN npm run build
## production environment
#FROM nginx:latest
#COPY --from=build /app/dist/toolshed/ /usr/share/nginx/html
#
#COPY ./nginx.conf /etc/nginx/conf.d/default.conf
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]


# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM library/node:20.10.0-bookworm as build
# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
#FROM node:latest as build

# Set the working directory
RUN mkdir /app
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

# Add the source code to app
COPY ./ /app

# Install all the dependencies
RUN npm install

# Generate the build of the application
RUN npm run build


# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/dist/nebular-test /usr/share/nginx/html

# Expose port 80
EXPOSE 80