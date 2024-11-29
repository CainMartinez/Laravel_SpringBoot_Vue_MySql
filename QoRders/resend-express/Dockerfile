# Use the official Node.js image as the base
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the server listens on
EXPOSE 3000

# Set the command to start the server
CMD ["npm", "run", "dev"]