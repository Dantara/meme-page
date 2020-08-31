# Base image
FROM fpco/stack-build:lts-16.12

# Creating working directory
WORKDIR /app

# Copy project files
COPY ./ /app

# Building project
RUN stack build --system-ghc

# Expose port
EXPOSE 8080

CMD stack exec meme-page-exe
