# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# ────────────────────────────────────────────────
FROM tomcat:9.0.111-jdk17

# ────────────────────────────────────────────────
# Versão e diretórios
# ────────────────────────────────────────────────
ENV GEOSERVER_VERSION=2.24.2
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir
ENV PROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver

# ────────────────────────────────────────────────
# Instalar wget e unzip
# ────────────────────────────────────────────────
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# ────────────────────────────────────────────────
# Preparar diretório GeoServer
# ────────────────────────────────────────────────
RUN rm -rf ${GEOSERVER_HOME} && mkdir -p ${GEOSERVER_HOME}

# ────────────────────────────────────────────────
# Descarregar e instalar WAR do GeoServer
# ────────────────────────────────────────────────
RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war /tmp/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip

RUN unzip /tmp/geoserver.war -d ${GEOSERVER_HOME} && rm /tmp/geoserver.war

# ────────────────────────────────────────────────
# Remover conteúdos pesados desnecessários
# ────────────────────────────────────────────────
RUN rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo

# ────────────────────────────────────────────────
# Copiar data_dir mínimo (já deve conter logs, workspaces e styles)
# ────────────────────────────────────────────────
COPY data_dir ${GEOSERVER_DATA_DIR}

# ────────────────────────────────────────────────
# Variáveis de contexto Tomcat
# ────────────────────────────────────────────────
ENV CATALINA_OPTS="-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} -DGEOSERVER_PROJ_DATA_DIR=${GEOSERVER_DATA_DIR}/proj -DPROXY_BASE_URL=${PROXY_BASE_URL}"

# ────────────────────────────────────────────────
# Expor porta padrão do Tomcat
# ────────────────────────────────────────────────
EXPOSE 8080

# ────────────────────────────────────────────────
# Diretório de trabalho
# ────────────────────────────────────────────────
WORKDIR /usr/local/tomcat

# ────────────────────────────────────────────────
# Iniciar Tomcat
# ────────────────────────────────────────────────
CMD ["catalina.sh", "run"]

