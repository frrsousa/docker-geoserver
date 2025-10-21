# Base leve com Java
FROM openjdk:17-jdk-slim

# Variáveis
ENV GEOSERVER_VERSION=2.24.2
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV JAVA_OPTS="-Xms128m -Xmx256m -Djava.awt.headless=true"

# Instalar dependências
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Instalar Tomcat leve
RUN curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz -o /tmp/tomcat.tar.gz && \
    tar xzf /tmp/tomcat.tar.gz -C /usr/local && \
    mv /usr/local/apache-tomcat-9.0.80 $CATALINA_HOME && \
    rm -rf /tmp/*

# Download e extração do GeoServer WAR
RUN mkdir -p $CATALINA_HOME/webapps/geoserver && \
    curl -L -o /tmp/geoserver.zip https://build.geoserver.org/geoserver/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip && \
    unzip -o /tmp/geoserver.zip -d /tmp && \
    unzip -o /tmp/geoserver.war -d $CATALINA_HOME/webapps/geoserver && \
    rm -rf /tmp/*

# Desativar GeoWebCache (reduz memória)
RUN mkdir -p $CATALINA_HOME/webapps/geoserver/WEB-INF/classes && \
    echo "GEOWEBCACHE_DISABLED=true" > $CATALINA_HOME/webapps/geoserver/WEB-INF/classes/geowebcache.properties

# Expor a porta
EXPOSE 8080

# Arranque
CMD ["catalina.sh", "run"]
