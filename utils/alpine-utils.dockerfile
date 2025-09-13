# Multi-stage build for smaller final image
FROM alpine:3.22.1

# Core system packages (rarely change)
RUN apk update && apk add --no-cache \
        ca-certificates \
        bash \
    && rm -rf /var/cache/apk/*

# Application tools (might change together)
RUN apk add --no-cache \
        curl \
        postgresql17-client \
        tar \
        git \
        nano \
        gzip
    
# Create a non-root user for security
RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser

# Create directories with proper permissions
RUN mkdir -p /app /app/backups /app/scripts && \
    chown -R appuser:appuser /app /app/backups /app/scripts

# Set working directory
WORKDIR /app

# Copy any scripts if needed (uncomment if you have scripts)
# COPY --chown=appuser:appuser scripts/ /scripts/
# RUN chmod +x /scripts/*

# Switch to non-root user
USER appuser

# Set environment variables
ENV PATH="/app/scripts:${PATH}"

# Default command
CMD ["/bin/bash"]
