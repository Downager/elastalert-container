FROM python:3.6-alpine

LABEL maintainer="relk.li@funpodium.net"\
      description="Elastalert on Docker & Kubernetes"

# Elastalert timezone
ENV TZ Asia/Taipei

# Elastalert Version https://github.com/Yelp/elastalert
ARG ELASTALERT_VERSION=0.2.1

RUN apk --update upgrade && \
    apk add gcc libffi-dev musl-dev python-dev openssl-dev tzdata libmagic && \
    rm -rf /var/cache/apk/*

RUN pip install elastalert==${ELASTALERT_VERSION} && \
    apk del gcc libffi-dev musl-dev python-dev openssl-dev

RUN mkdir -p /opt/elastalert/config && \
    mkdir -p /opt/elastalert/rules && \
    echo "#!/bin/sh" >> /opt/elastalert/docker-entrypoint.sh && \
    echo "elastalert-create-index --config /opt/config/elastalert_config.yaml" >> /opt/elastalert/docker-entrypoint.sh && \
    echo "exec elastalert --verbose --config /opt/config/elastalert_config.yaml" >> /opt/elastalert/docker-entrypoint.sh && \
    chmod +x /opt/elastalert/docker-entrypoint.sh

VOLUME [ "/opt/config", "/opt/rules" ]

WORKDIR /opt/elastalert

ENTRYPOINT ["/opt/elastalert/docker-entrypoint.sh"]