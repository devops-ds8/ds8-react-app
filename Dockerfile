# Use an official Node.js runtime as the base image
FROM node:18

# Set the working directory in the Docker container
WORKDIR /usr/src/app

# Copy package.json and yarn.lock files to the working directory
COPY package.json ./
COPY yarn.lock ./

# Install the application dependencies
RUN yarn install

# Copy the rest of the application code to the working directory
COPY . .

# Expose port 3003 for the application
EXPOSE 3003

# Define the command to run the application
CMD [ "yarn", "start" ]