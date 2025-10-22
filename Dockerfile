# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# ────────────────────────────────────────────────
FROM tomcat:9.0.111-jdk17

ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver

# Instalar wget e unzip para descarregar e extrair o WAR
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Criar diretório GeoServer
RUN mkdir -p ${GEOSERVER_HOME}

# Descarregar WAR oficial do GeoServer
RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/2.24.2/geoserver-2.24.2-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war ${GEOSERVER_HOME}/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip

# Descompactar WAR e remover conteúdo pesado desnecessário
RUN unzip ${GEOSERVER_HOME}/geoserver.war -d ${GEOSERVER_HOME} && \
    rm ${GEOSERVER_HOME}/geoserver.war && \
    rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo

# Criar WEB-INF/web.xml mínimo para desativar CSRF
RUN mkdir -p ${GEOSERVER_HOME}/WEB-INF && \
    echo '<?xml version="1.0" encoding="UTF-8"?>\
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" \
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" \
xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd" \
version="3.1">\
  <context-param>\
    <param-name>GEOSERVER_CSRF_ENABLED</param-name>\
    <param-value>false</param-value>\
  </context-param>\
</web-app>' > ${GEOSERVER_HOME}/WEB-INF/web.xml

# Copiar o data_dir mínimo que tens
COPY data_dir ${GEOSERVER_HOME}/data_dir

# Expor porta do Tomcat
EXPOSE 8080

# Arrancar Tomcat
WORKDIR /usr/local/tomcat
CMD ["catalina.sh", "run"]
