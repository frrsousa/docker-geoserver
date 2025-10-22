# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# ────────────────────────────────────────────────
FROM tomcat:9.0.111-jdk17

ENV GEOSERVER_VERSION=2.24.2
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver

# Instalar wget e unzip
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Garantir diretório limpo
RUN rm -rf ${GEOSERVER_HOME} && mkdir -p ${GEOSERVER_HOME}

# Descarregar WAR oficial do GeoServer
RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war /tmp/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip

# Descompactar WAR dentro do contexto GeoServer
RUN unzip /tmp/geoserver.war -d ${GEOSERVER_HOME} && rm /tmp/geoserver.war

# Remover conteúdos pesados desnecessários (docs, demo)
RUN rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo

# Copiar data_dir mínimo
COPY data_dir ${GEOSERVER_HOME}/data_dir

# Copiar web.xml modificado com CORS
COPY web-inf/web.xml ${GEOSERVER_HOME}/WEB-INF/web.xml

# Expor porta padrão do Tomcat
EXPOSE 8080

# Definir diretório de trabalho
WORKDIR /usr/local/tomcat

# Arrancar Tomcat
CMD ["catalina.sh", "run"]

