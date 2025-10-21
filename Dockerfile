# Imagem base leve com Java 17
FROM openjdk:17-jdk-slim

# Versão do GeoServer
ENV GEOSERVER_VERSION=2.24.2
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# Ajustar memória (essencial para Render Free Tier)
ENV JAVA_OPTS="-Xms64m -Xmx256m -Djava.awt.headless=true"

# Instalar dependências
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Instalar Tomcat leve
RUN curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz -o /tmp/tomcat.tar.gz && \
    tar xzf /tmp/tomcat.tar.gz -C /usr/local && \
    mv /usr/local/apache-tomcat-9.0.80 $CATALINA_HOME && \
    rm -rf /tmp/*

# Descarregar e extrair GeoServer WAR
RUN mkdir -p $CATALINA_HOME/webapps/geoserver && \
    curl -L -o /tmp/geoserver-war.zip "https://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip" && \
    unzip -o /tmp/geoserver-war.zip -d /tmp && \
    unzip -o /tmp/geoserver.war -d $CATALINA_HOME/webapps/geoserver && \
    rm -rf /tmp/*

# Remover a interface web (mantém apenas WMS/WFS)
RUN rm -rf $CATALINA_HOME/webapps/geoserver/web

# Desativar GeoWebCache para reduzir memória
RUN echo "GEOWEBCACHE_DISABLED=true" > $CATALINA_HOME/webapps/geoserver/WEB-INF/classes/geowebcache.properties

# Porta usada pelo Tomcat
EXPOSE 8080

# Comando de arranque
CMD ["catalina.sh", "run"]
