# Etapa base leve com Java
FROM openjdk:17-jdk-slim

# Definir variáveis de ambiente
ENV GEOSERVER_VERSION=2.24.2
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV JAVA_OPTS="-Xms128m -Xmx256m -Djava.awt.headless=true"

# Instalar Tomcat
RUN apt-get update && apt-get install -y curl unzip && \
    mkdir -p $CATALINA_HOME && \
    curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz -o /tmp/tomcat.tar.gz && \
    tar xzf /tmp/tomcat.tar.gz -C /usr/local && \
    mv /usr/local/apache-tomcat-9.0.80 $CATALINA_HOME && \
    rm -rf /tmp/* /var/lib/apt/lists/*

# Fazer download do GeoServer "lite" WAR (sem extensões pesadas)
RUN curl -fsSL -o /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    cp /tmp/geoserver/geoserver-${GEOSERVER_VERSION}/webapps/geoserver.war $CATALINA_HOME/webapps/ && \
    rm -rf /tmp/*

# Desativar GeoWebCache para poupar memória
RUN mkdir -p $CATALINA_HOME/webapps/geoserver/WEB-INF/classes && \
    echo "GEOWEBCACHE_DISABLED=true" > $CATALINA_HOME/webapps/geoserver/WEB-INF/classes/geowebcache.properties

# Expor a porta
EXPOSE 8080

# Arranque do Tomcat
CMD ["catalina.sh", "run"]
