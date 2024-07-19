FROM openjdk:11-jre-slim

EXPOSE 8080

ARG GEOSERVER_VERSION=2.25.2
ARG GEOSERVER_MINOR=2.25
ENV JAVA_OPTS -Xms256m  -Xmx1g
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

# Vector Tiles Plugin
RUN wget -c https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip \
    -O /tmp/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip -d /tmp/geoserver-plugins && \
    cp /tmp/geoserver-plugins/*.jar /opt/geoserver-${GEOSERVER_VERSION}/webapps/geoserver/WEB-INF/lib/ && \
    rm -rf /tmp/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip /tmp/geoserver-plugins

# MBStyle Plugin
RUN wget -c https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-mbstyle-plugin.zip \
    -O /tmp/geoserver-${GEOSERVER_VERSION}-mbstyle-plugin.zip && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-mbstyle-plugin.zip -d /tmp/geoserver-plugins && \
    cp /tmp/geoserver-plugins/*.jar /opt/geoserver-${GEOSERVER_VERSION}/webapps/geoserver/WEB-INF/lib/ && \
    rm -rf /tmp/geoserver-${GEOSERVER_VERSION}-mbstyle-plugin.zip /tmp/geoserver-plugins

# MBTiles Plugin
RUN wget -c https://build.geoserver.org/geoserver/2.25.x/community-latest/geoserver-2.25-SNAPSHOT-mbtiles-plugin.zip \
    -O /tmp/geoserver-2.25-SNAPSHOT-mbtiles-plugin.zip && \
    unzip /tmp/geoserver-2.25-SNAPSHOT-mbtiles-plugin.zip -d /tmp/geoserver-plugins && \
    cp /tmp/geoserver-plugins/*.jar /opt/geoserver-${GEOSERVER_VERSION}/webapps/geoserver/WEB-INF/lib/ && \
    rm -rf /tmp/geoserver-2.25-SNAPSHOT-mbtiles-plugin.zip /tmp/geoserver-plugins

# GeoPackage plugin 
RUN wget -c https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-geopkg-output-plugin.zip \
    -O /tmp/geoserver-${GEOSERVER_VERSION}-geopkg-output-plugin.zip && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-geopkg-output-plugin.zip -d /tmp/geoserver-plugins && \
    cp /tmp/geoserver-plugins/*.jar /opt/geoserver-${GEOSERVER_VERSION}/webapps/geoserver/WEB-INF/lib/ && \
    rm -rf /tmp/geoserver-${GEOSERVER_VERSION}-geopkg-output-plugin.zip /tmp/geoserver-plugins

#  WPS plugin 
RUN wget -c https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-wps-plugin.zip \
    -O /tmp/geoserver-${GEOSERVER_VERSION}-wps-plugin.zip && \
    unzip /tmp/geoserver-${GEOSERVER_VERSION}-wps-plugin.zip -d /tmp/geoserver-plugins && \
    cp /tmp/geoserver-plugins/*.jar /opt/geoserver-${GEOSERVER_VERSION}/webapps/geoserver/WEB-INF/lib/ && \
    rm -rf /tmp/geoserver-${GEOSERVER_VERSION}-wps-plugin.zip /tmp/geoserver-plugins


RUN chown -R geoserver:geoserver /opt/geoserver-${GEOSERVER_VERSION}
USER geoserver

WORKDIR /opt/geoserver

CMD ["/opt/geoserver/bin/startup.sh"]
