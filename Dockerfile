# FROM ghcr.io/linuxserver/baseimage-alpine:3.20
FROM alpine

#Requirements Installation
RUN apk add --no-cache \
        bash \
        openssh \
    && rm -rf \
        /tmp/* \
    && echo "done" 

#Security Provisions
RUN sed -i 's/root:!/root:*/' /etc/shadow \
    && sed -i "s/.*PasswordAuthentication .*/PasswordAuthentication no/g" /etc/ssh/sshd_config \
    && echo "configured security settings"

ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY root/ /

ENTRYPOINT [ "dockerentry" ]