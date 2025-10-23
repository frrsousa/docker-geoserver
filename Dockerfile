# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# ────────────────────────────────────────────────
FROM tomcat:9.0.111-jdk17

ENV GEOSERVER_VERSION=2.24.2
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir

# Instalar wget e unzip
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Garantir diretórios limpos
RUN rm -rf ${GEOSERVER_HOME} && mkdir -p ${GEOSERVER_HOME}

# Descarregar e descompactar GeoServer WAR
RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war /tmp/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip && \
    unzip /tmp/geoserver.war -d ${GEOSERVER_HOME} && \
    rm /tmp/geoserver.war

# Remover ficheiros pesados (documentação, demo)
RUN rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo

# Copiar data_dir mínimo (já com styles, logs, security, etc.)
COPY data_dir ${GEOSERVER_DATA_DIR}

# Copiar web.xml para dentro de WEB-INF do Tomcat
COPY data_dir/web-inf/web.xml ${GEOSERVER_HOME}/WEB-INF/web.xml

# Garantir permissões adequadas (evita erro 400 e falhas de escrita)
RUN chmod -R 777 ${GEOSERVER_DATA_DIR} && \
    chmod -R 755 ${GEOSERVER_HOME} && \
    chown -R root:root ${GEOSERVER_HOME}

# Definir variáveis no contexto Tomcat
ENV CATALINA_OPTS="-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} \
-DGEOSERVER_PROJ_DATA_DIR=${GEOSERVER_DATA_DIR}/proj \
-DPROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver"

# Expor porta padrão
EXPOSE 8080

# Diretório de trabalho e arranque
WORKDIR /usr/local/tomcat
CMD ["catalina.sh", "run"]
