# ---- GeoServer Lite para Render (512 MB RAM) ----
FROM openjdk:17-jdk-slim

ENV GEOSERVER_VERSION=2.24.2
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV JAVA_OPTS="-Xms64m -Xmx256m -Djava.awt.headless=true -DGEOWEBCACHE_DISABLED=true"

# Instalar dependências essenciais
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Instalar Tomcat leve
RUN curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz -o /tmp/tomcat.tar.gz && \
    tar xzf /tmp/tomcat.tar.gz -C /usr/local && \
    mv /usr/local/apache-tomcat-9.0.80 $CATALINA_HOME && \
    rm -rf /tmp/*

# Descarregar e instalar GeoServer WAR
RUN mkdir -p $CATALINA_HOME/webapps/geoserver && \
    curl -L -o /tmp/geoserver-war.zip "https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download" && \
    unzip -o /tmp/geoserver-war.zip -d /tmp && \
    unzip -o /tmp/geoserver.war -d $CATALINA_HOME/webapps/geoserver && \
    rm -rf /tmp/*

# Remover interface web e desativar caches
RUN rm -rf $CATALINA_HOME/webapps/geoserver/web && \
    echo "GEOWEBCACHE_DISABLED=true" > $CATALINA_HOME/webapps/geoserver/WEB-INF/classes/geowebcache.properties

EXPOSE 8080

CMD ["catalina.sh", "run"]
RUN ls -l /usr/local/tomcat/webapps/
