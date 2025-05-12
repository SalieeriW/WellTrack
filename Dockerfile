# Use a Bun base image
FROM oven/bun:latest

# Set the working directory inside the container
WORKDIR /app

# Copy package files to install dependencies
COPY package.json ./

# Install dependencies using Bun
RUN bun install

# Copy the rest of your frontend files
COPY . ./

# Expose the port your frontend runs on
EXPOSE 3000

# Start the frontend app using Bun
CMD ["bun", "run", "dev"]