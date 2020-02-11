# Start with docker image
FROM docker:dind

# Git
RUN apk add --no-cache git

# Bash
RUN apk add bash

# Files
COPY entrypoint.sh /usr/local/bin/entrypoint
COPY gitdiff.sh /usr/local/bin/gitdiff

ENTRYPOINT ["entrypoint"]
