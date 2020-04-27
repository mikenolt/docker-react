# Use an existing docker image as a base
# This is the alpine (stripped down) version with just node installed
FROM node:alpine as builder

# Set the  workdir dir inside the image
WORKDIR /app

# Copy just the package.json into the image
COPY ./package.json ./

# Download and install a dependency
RUN npm install

# Copy the rest
# This will prevent you from having to rerun npm install
# when you change any other file
COPY . .

# Build it
RUN npm run build

# End build phase

# Start run phase

FROM nginx
EXPOSE 80

# Copy the build directory from npm run build to the nginx dir
COPY --from=builder /app/build /usr/share/nginx/html

# End run phase

