FROM alpine
MAINTAINER Leandro Pedroni <ilpoldo@gmail.com>

ENV DKRON_VERSION 0.9.4
ENV FAAS_CLI_VERSION 0.5.0

RUN set -x \
  && buildDeps='bash ca-certificates openssl' \
  && apk add --update $buildDeps \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /opt/local/dkron \
  && wget -O dkron.tar.gz https://github.com/victorcoder/dkron/releases/download/v${DKRON_VERSION}/dkron_${DKRON_VERSION}_linux_amd64.tar.gz \
  && tar -xzf dkron.tar.gz \
  && mv dkron_${DKRON_VERSION}_linux_amd64/* /opt/local/dkron \
  && rm dkron.tar.gz \
  && rm -rf dkron_${DKRON_VERSION}_linux_amd64 \

RUN echo "Pulling faas-cli binary from Github." \
    && wget -O /usr/local/bin/faas-cli https://github.com/openfaas/faas-cli/releases/download/0.5.0/faas-cli \
    && chmod +x /usr/local/bin/faas-cli

EXPOSE 8080 8946

ENV SHELL /bin/bash
WORKDIR /opt/local/dkron

ENTRYPOINT ["/opt/local/dkron/dkron"]

CMD ["--help"]