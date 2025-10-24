# --------------------------------------------------------------------
# 🛰️ GeoServer personalizado para Render
# Versão estável baseada em 2.24.2 (testada e funcional no Render)
# --------------------------------------------------------------------
FROM docker.osgeo.org/geoserver:2.24.2

# Define variáveis de ambiente
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver \
    GEOSERVER_DATA_DIR=/usr/local/tomcat/webapps/geoserver/data_dir \
    PROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver \
    GEOSERVER_CSRF_DISABLED=true

# Copia o data_dir completo
COPY data_dir ${GEOSERVER_DATA_DIR}

# Copia os ficheiros da interface web
COPY data_dir/web/accessDenied.jsp ${GEOSERVER_DATA_DIR}/web/accessDenied.jsp
COPY data_dir/web-inf/web.xml ${GEOSERVER_HOME}/WEB-INF/web.xml

# Define permissões para o GeoServer poder escrever no diretório
RUN chmod -R 777 ${GEOSERVER_DATA_DIR} && \
    mkdir -p ${GEOSERVER_DATA_DIR}/logs && \
    chmod -R 777 ${GEOSERVER_DATA_DIR}/logs

# Define o workspace padrão (meu_workspace)
ENV DEFAULT_WORKSPACE=meu_workspace

# Exposição da porta do Tomcat
EXPOSE 8080

# Inicia o GeoServer
CMD ["catalina.sh", "run"]
