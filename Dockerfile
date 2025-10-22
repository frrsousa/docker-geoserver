# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# ────────────────────────────────────────────────
FROM eclipse-temurin:17-jre-slim

ENV GEOSERVER_VERSION=2.24.2
ENV GEOSERVER_HOME=/usr/local/geoserver
ENV JAVA_OPTS="-Xms128m -Xmx384m"

# Instalar dependências mínimas
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Criar diretórios
RUN mkdir -p ${GEOSERVER_HOME}/webapps/geoserver

# Descarregar e extrair apenas o WAR
RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war ${GEOSERVER_HOME}/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip

# Descompactar e limpar conteúdo desnecessário
RUN unzip ${GEOSERVER_HOME}/geoserver.war -d ${GEOSERVER_HOME}/webapps/geoserver && \
    rm ${GEOSERVER_HOME}/geoserver.war && \
    rm -rf ${GEOSERVER_HOME}/webapps/geoserver/doc ${GEOSERVER_HOME}/webapps/geoserver/data ${GEOSERVER_HOME}/webapps/geoserver/demo

# Copiar data_dir mínimo
COPY data_dir ${GEOSERVER_HOME}/data_dir

# Porta padrão do GeoServer
EXPOSE 8080

WORKDIR ${GEOSERVER_HOME}/webapps/geoserver

# Iniciar GeoServer
CMD ["java", "-jar", "start.jar"]
