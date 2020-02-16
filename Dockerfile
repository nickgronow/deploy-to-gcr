# Start with docker image
FROM docker:dind

# Git
RUN apk add --no-cache git

# Bash
RUN apk add bash

# Files
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
