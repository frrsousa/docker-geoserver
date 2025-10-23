# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# ────────────────────────────────────────────────
FROM tomcat:9.0.111-jdk17

ENV GEOSERVER_VERSION=2.24.2
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir

# Instalar wget e unzip
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Garantir diretório limpo
RUN rm -rf ${GEOSERVER_HOME} && mkdir -p ${GEOSERVER_HOME}

# Descarregar WAR oficial do GeoServer
RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war /tmp/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip

# Descompactar WAR dentro do contexto geoserver
RUN unzip /tmp/geoserver.war -d ${GEOSERVER_HOME} && rm /tmp/geoserver.war

# Remover conteúdos pesados desnecessários
RUN rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo

# Criar pastas mínimas do data_dir
RUN mkdir -p ${GEOSERVER_DATA_DIR}/logs \
    ${GEOSERVER_DATA_DIR}/styles \
    ${GEOSERVER_DATA_DIR}/workspaces/meu_workspace \
    && chmod -R 777 ${GEOSERVER_DATA_DIR} \
    && chown -R root:root ${GEOSERVER_HOME}

# Copiar data_dir mínimo para dentro do GeoServer
COPY data_dir/ ${GEOSERVER_DATA_DIR}/

# Definir variáveis no Tomcat
ENV CATALINA_OPTS="-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} \
    -DGEOSERVER_PROJ_DATA_DIR=${GEOSERVER_DATA_DIR}/proj \
    -DPROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver"

# Expor porta padrão do Tomcat
EXPOSE 8080

# Definir diretório de trabalho
WORKDIR /usr/local/tomcat

# Arrancar Tomcat
CMD ["catalina.sh", "run"]

