FROM openjdk:11-jre-slim

MAINTAINER Matthew Benstead <matthewb@uvic.ca>

EXPOSE 8080

ARG GEOSERVER_VERSION=2.17.2

ENV JAVA_OPTS -Xms128m -Xmx512m -XX:MaxPermSize=512m
ENV GEOSERVER_HOME /opt/geoserver
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

RUN apt-get update && apt-get install -y openssl unzip wget && rm -rf /var/lib/apt/lists/* 
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip \
         -O /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip && \
    mkdir -p /opt/geoserver-${GEOSERVER_VERSION} && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip -d /opt/geoserver-${GEOSERVER_VERSION} && \
    cd /opt && \
    ln -s geoserver-${GEOSERVER_VERSION} geoserver && \
    rm /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip

WORKDIR /opt/geoserver

CMD ["/opt/geoserver/bin/startup.sh"]
