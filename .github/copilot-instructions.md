# Andy Image GDAL - AI Agent Instructions

## Project Overview
This project builds a comprehensive Docker image for geospatial data processing, web scraping, and data analysis. The image (`andy-image`) extends OSGeo GDAL with a curated toolkit of modern data processing tools.

## Architecture
- **Base**: `ghcr.io/osgeo/gdal:ubuntu-full-latest` - provides GDAL with all drivers
- **Tool Stack**: Multi-language environment with Python (uv), Node.js, and standalone binaries
- **Package Manager**: Uses `uv` for Python tools installation and package management
- **Registry**: Published to GitHub Container Registry (`ghcr.io/aborruso/andy-image:latest`)

## Key Tools Included
- **Geospatial**: GDAL (with GeoParquet support), built-in from base image
- **Data Processing**: xan (CSV), miller, duckdb, frictionless, flatterer
- **Web Scraping**: scrape-cli, playwright, puppeteer, beautifulsoup4, chromium
- **Data Formats**: yq (YAML), jq (JSON), xmlstarlet (XML)
- **Analysis**: visidata, ckanapi
- **System**: git (configured for CI/CD), curl, wget

## Development Workflow

### Building the Image
```bash
docker build -t andy-image .
```

### Testing Locally
```bash
docker run -it --rm -v $(pwd):/workspace andy-image /bin/bash
```

### GitHub Actions Workflows
- **`docker-build.yml`**: Builds and pushes on every main branch push/PR
- **`test-andy-image.yml`**: Manual testing workflow to verify tool availability

### Registry Authentication
The build uses a dual authentication strategy:
1. **Primary**: `GHCR_PAT` secret (Personal Access Token with `write:packages` scope)
2. **Fallback**: `GITHUB_TOKEN` (may require repository permissions adjustment)

## Project-Specific Patterns

### Tool Installation Strategy
- **Standalone tools**: Installed via `uv tool install` (isolated environments)
- **System Python packages**: Installed with `--system --break-system-packages` flags
- **Latest releases**: xan uses dynamic GitHub API lookup for latest version
- **Retry logic**: xan installation includes 3-attempt retry mechanism

### Environment Configuration
- PATH includes `/root/.local/bin` for uv tools
- Git configured with `safe.directory '*'` for CI/CD compatibility
- Working directory set to `/workspace` for mounted volumes

### Testing Approach
The test workflow (`test-andy-image.yml`) verifies:
- Core tools are available and functional
- GDAL GeoParquet support is enabled
- All major installed tools respond correctly

## File Structure
```
├── Dockerfile              # Main image definition
├── REGISTRY.md             # GHCR setup instructions (Italian)
└── .github/workflows/
    ├── docker-build.yml    # Automated build/push
    └── test-andy-image.yml # Manual testing
```

## When Modifying Tools
1. **Adding Python tools**: Use `uv tool install` for CLI tools, `uv pip install --system` for libraries
2. **Adding system packages**: Add to the main `apt-get install` block
3. **Adding Node.js packages**: Use `npm install -g`
4. **Testing changes**: Always update `test-andy-image.yml` to verify new tools work

## Common Issues
- **Package conflicts**: Use `uv` isolation to prevent Python package conflicts
- **PATH issues**: Ensure new binaries are in PATH or use absolute paths
- **Registry push failures**: Check `GHCR_PAT` secret or repository package permissions
- **Size optimization**: Remove package caches with `rm -rf /var/lib/apt/lists/*`
