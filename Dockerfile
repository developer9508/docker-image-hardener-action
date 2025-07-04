FROM python:3.11-slim

# Install Trivy
RUN apt-get update && \
    apt-get install -y curl unzip gnupg && \
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Set working directory
WORKDIR /app

# Copy the CLI code (adjusted path relative to Dockerfile)
COPY cli /app/cli

# Add entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
