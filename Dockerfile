# ────────────────────────────────────────────────
# BASE IMAGE
# ────────────────────────────────────────────────
FROM tomcat:9-jdk17-temurin

# ────────────────────────────────────────────────
# VARIÁVEIS DE AMBIENTE
# ────────────────────────────────────────────────
ENV GEOSERVER_VERSION=2.23.2
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir
ENV CATALINA_OPTS="-Xms512m -Xmx1024m -DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} -Dshutdown.port=-1"

# ────────────────────────────────────────────────
# INSTALA DEPENDÊNCIAS
# ────────────────────────────────────────────────
RUN apt-get update && apt-get install -y wget unzip && apt-get clean

# ────────────────────────────────────────────────
# INSTALA GEOSERVER
# ────────────────────────────────────────────────
RUN wget -q https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip && \
    unzip geoserver-${GEOSERVER_VERSION}-war.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war ${CATALINA_HOME}/webapps/geoserver.war && \
    rm -rf /tmp/geoserver geoserver-${GEOSERVER_VERSION}-war.zip

# ────────────────────────────────────────────────
# COPIAR DATA_DIR PERSONALIZADO
# ────────────────────────────────────────────────
COPY data_dir ${GEOSERVER_DATA_DIR}

# ────────────────────────────────────────────────
# GARANTIR PERMISSÕES ADEQUADAS
# ────────────────────────────────────────────────
RUN mkdir -p ${GEOSERVER_DATA_DIR}/logs && \
    chmod -R 777 ${GEOSERVER_DATA_DIR} && \
    chmod -R 755 ${GEOSERVER_HOME} && \
    chown -R root:root ${GEOSERVER_HOME}

# ────────────────────────────────────────────────
# CONFIGURAÇÕES DE REDE
# ────────────────────────────────────────────────
EXPOSE 8080

# ────────────────────────────────────────────────
# INICIAR TOMCAT
# ────────────────────────────────────────────────
CMD ["catalina.sh", "run"]

