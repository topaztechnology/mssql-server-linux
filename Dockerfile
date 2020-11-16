FROM mcr.microsoft.com/mssql/server:2019-CU8-ubuntu-16.04
LABEL maintainer="info@topaz.technology"

# To meet SQL Server complexity requirements
ENV SA_PASSWORD P4ssw0rd

# Containerpilot version
ENV CONTAINERPILOT_VERSION 3.8.0
ENV CONTAINERPILOT_RELEASES https://github.com/joyent/containerpilot/releases/download
ENV CONTAINERPILOT_CHECKSUM 84642c13683ddae6ccb63386e6160e8cb2439c26

USER root

RUN \
  apt-get update && \
  apt-get install -y curl unzip gettext

# Install Containerpilot
RUN \
  curl -Lso /tmp/containerpilot.tar.gz \
    "${CONTAINERPILOT_RELEASES}/${CONTAINERPILOT_VERSION}/containerpilot-${CONTAINERPILOT_VERSION}.tar.gz" && \
  echo "${CONTAINERPILOT_CHECKSUM}  /tmp/containerpilot.tar.gz" | sha1sum -c && \
  tar zxvf /tmp/containerpilot.tar.gz -C /usr/local/bin && \
  rm /tmp/containerpilot.tar.gz

RUN \
  curl -Lso /tmp/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=873926 && \
  unzip -qq /tmp/sqlpackage.zip -d /opt/sqlpackage && \
  chmod +x /opt/sqlpackage/sqlpackage && \
  rm /tmp/sqlpackage.zip 

RUN \
  mkdir /init.bacpac \
  mkdir /init.sql \
  mkdir -p /opt/mssql-init/bin \
  mkdir -p /opt/mssql-init/sql

COPY bin/* /opt/mssql-init/bin/
COPY sql/* /opt/mssql-init/sql/
COPY containerpilot.json5 /etc/containerpilot.json5

ENV CONTAINERPILOT /etc/containerpilot.json5

CMD ["/usr/local/bin/containerpilot"]
