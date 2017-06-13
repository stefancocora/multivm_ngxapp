FROM alpine:latest

MAINTAINER stefan.cocora@gmail.com

RUN apk -U --no-cache add bash nginx

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]


