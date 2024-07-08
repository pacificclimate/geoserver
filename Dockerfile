FROM openjdk:11-jre-slim

EXPOSE 8080

ARG GEOSERVER_VERSION=2.25.2
ARG GEOSERVER_MINOR=2.25
ENV JAVA_OPTS -Xms128m -Xmx512m -XX:MaxPermSize=512m
ENV GEOSERVER_HOME /opt/geoserver
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

RUN apt-get update && \
    apt-get install -y openssl unzip wget fontconfig fonts-dejavu-core fonts-dejavu-extra  && \
    rm -rf /var/lib/apt/lists/* 
RUN groupadd -r -g 30669 geoserver && \
    useradd -r -u 30669 -d /opt/geoserver -g geoserver geoserver && \
    mkdir -p /opt/geoserver-${GEOSERVER_VERSION} && \
    cd /opt && \
    ln -s geoserver-${GEOSERVER_VERSION} geoserver && \
    chown -R geoserver:geoserver /opt/geoserver

RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip \
    -O /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip -d /opt/geoserver-${GEOSERVER_VERSION} && \
    rm /tmp/geoserver-${GEOSERVER_VERSION}-bin.zip

RUN chown -R geoserver:geoserver /opt/geoserver-${GEOSERVER_VERSION}
USER geoserver

WORKDIR /opt/geoserver

CMD ["/opt/geoserver/bin/startup.sh"]
