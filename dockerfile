# Base image using Ubuntu
FROM ubuntu:22.04

# Set non-interactive mode during build
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install Foldseek
WORKDIR /opt
RUN wget https://mmseqs.com/foldseek/foldseek-linux-avx2.tar.gz \
    && tar xvzf foldseek-linux-avx2.tar.gz \
    && rm foldseek-linux-avx2.tar.gz

# Add Foldseek to PATH
ENV PATH="/opt/foldseek/bin:${PATH}"

# Set working directory
WORKDIR /data

# Keep container running
CMD ["tail", "-f", "/dev/null"]