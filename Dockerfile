FROM gliderlabs/alpine

RUN apk update && \
    apk add --update alpine-sdk && \
    apk add --update nodejs && \
    apk -v cache clean

