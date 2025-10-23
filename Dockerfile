# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# Corrigido para permissões e workspace pré-carregado
# ────────────────────────────────────────────────
FROM tomcat:9.0.111-jdk17

ENV GEOSERVER_VERSION=2.24.2
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir

# Instalar wget e unzip
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Garantir diretório limpo e preparado
RUN rm -rf ${GEOSERVER_HOME} && mkdir -p ${GEOSERVER_DATA_DIR}

# Descarregar WAR oficial do GeoServer
RUN wget -O /tmp/geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war /tmp/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip

# Descompactar WAR dentro do contexto geoserver
RUN unzip /tmp/geoserver.war -d ${GEOSERVER_HOME} && rm /tmp/geoserver.war

# Remover conteúdos desnecessários (docs, demos)
RUN rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo

# Copiar data_dir mínimo
COPY data_dir ${GEOSERVER_DATA_DIR}

# ────────────────────────────────────────────────
# Corrigir permissões para o Render (sem shell)
# ────────────────────────────────────────────────
RUN chmod -R 777 ${GEOSERVER_DATA_DIR} || true
RUN chmod -R 755 ${GEOSERVER_HOME} || true

# Variáveis de ambiente obrigatórias
ENV CATALINA_OPTS="-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} \
                   -DGEOSERVER_PROJ_DATA_DIR=${GEOSERVER_DATA_DIR}/proj \
                   -DPROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver"

# Expor porta padrão
EXPOSE 8080

# Definir diretório de trabalho e iniciar Tomcat
WORKDIR /usr/local/tomcat
CMD ["catalina.sh", "run"]


