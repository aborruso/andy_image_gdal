# Dockerfile for andy_image_gdal
# Base image with GDAL and its drivers pre-installed
FROM ghcr.io/osgeo/gdal:ubuntu-full-latest

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_CACHE_DIR=1
# Ensure ~/.local/bin is in PATH for uv tools
ENV PATH="/root/.local/bin:${PATH}"

# Update package lists and install common system packages
# Note: Some of these might already be in the base GDAL image, but re-installing is safe.
# We'll remove redundant ones if they cause issues or significantly increase size.
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium curl wget jq miller xmlstarlet git build-essential \
    && rm -rf /var/lib/apt/lists/*

# Configure git for CI/CD environments
RUN git config --global --add safe.directory '*'

# Install uv
RUN curl -Ls https://astral.sh/uv/install.sh | sh

# Install scrape-cli, yq, flatterer, frictionless, ckanapi, visidata as stand-alone tools
RUN uv tool install scrape-cli \
    && uv tool install yq \
    && uv tool install flatterer \
    && uv tool install frictionless \
    && uv tool install ckanapi \
    && uv tool install visidata

# Shared Python libraries (GDAL is already in the base image)
RUN pip install \
    requests beautifulsoup4 playwright==1.44.0 requests-aws4auth

# Working directory
WORKDIR /workspace

# Install Node.js (from NodeSource) and global npm packages
# Check if Node.js is already in the base GDAL image. If not, this is needed.
# Assuming it's not, or we want a specific version from NodeSource.
RUN apt-get update \
    && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g puppeteer playwright \
    && rm -rf /var/lib/apt/lists/*

# Install duckdb
RUN curl https://install.duckdb.org | sh

# Install xan (latest release, x86_64-unknown-linux-musl)
RUN set -eux; \
    for i in 1 2 3; do \
      XAN_URL=$(curl -s --fail --retry 3 https://api.github.com/repos/medialab/xan/releases/latest | \
        jq -r '.assets[] | select(.name | endswith("x86_64-unknown-linux-musl.tar.gz")) | .browser_download_url'); \
      if [ -n "$XAN_URL" ]; then break; fi; \
      echo "Attempt $i failed. Retrying in 5 seconds..."; \
      sleep 5; \
    done; \
    echo "XAN_URL: $XAN_URL"; \
    if [ -z "$XAN_URL" ]; then echo "XAN_URL not found"; exit 1; fi; \
    curl -L "$XAN_URL" -o /tmp/xan.tar.gz; \
    tar -xzf /tmp/xan.tar.gz -C /tmp; \
    mv /tmp/xan /usr/local/bin/xan; \
    chmod +x /usr/local/bin/xan; \
    rm /tmp/xan.tar.gz
