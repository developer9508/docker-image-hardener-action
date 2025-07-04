FROM python:3.11-slim

# Install Trivy
RUN apt-get update && \
    apt-get install -y curl unzip gnupg && \
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Set working dir
WORKDIR /app

# Copy the CLI code
COPY ../../cli /app/cli

# Add entrypoint
COPY .github/actions/docker-hardener/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
