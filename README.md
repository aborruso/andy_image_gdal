# Andy Image GDAL

This repository contains a Docker image built on top of OSGeo's GDAL Ubuntu Full image, extended with various command-line tools and Python libraries for geospatial data processing, web scraping, and data manipulation.

## Docker Image

The Docker image is available on GitHub Container Registry:

`ghcr.io/aborruso/andy_image_gdal:latest`

## How to Use

To use this Docker image, you need to have Docker installed on your system.

### 1. Pull the Docker Image

```bash
docker pull ghcr.io/aborruso/andy_image_gdal:latest
```

### 2. Run the Docker Image

You can run the Docker image and access its command-line tools. For example, to start an interactive shell:

```bash
docker run -it ghcr.io/aborruso/andy_image_gdal:latest /bin/bash
```

Once inside the container, you can use the pre-installed tools:

*   **GDAL/OGR**: For geospatial data processing.
    ```bash
ogrinfo --version
    ```

*   **Python**: With `uv` for package management.
    ```bash
python --version
    ```

*   **`scrape-cli`**: For web scraping.
    ```bash
scrape --version
    ```

*   **`jq`**: For JSON processing.
    ```bash
jq --version
    ```

*   **`duckdb`**: For in-process SQL OLAP database.
    ```bash
duckdb --version
    ```

*   **`xan`**: A command-line tool for data manipulation.
    ```bash
xan --help
    ```

*   **AWS CLI v2**: For interacting with AWS services.
    ```bash
aws --version
    ```

### 3. Mount Local Volumes (Optional)

If you need to process local files, you can mount a local directory into the Docker container:

```bash
docker run -it -v /path/to/your/local/data:/workspace ghcr.io/aborruso/andy_image_gdal:latest /bin/bash
```

Replace `/path/to/your/local/data` with the actual path on your machine. Inside the container, your data will be available in the `/workspace` directory.
