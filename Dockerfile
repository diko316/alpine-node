FROM sillelien/base-alpine

RUN apk update && \
    apk add --update alpine-sdk && \
    apk add --update nodejs

