# --------------------------------------------------------------------
# 🌍 GeoServer personalizado (modo debug) para Render
# Base: GeoServer 2.24.2 (Tomcat 9)
# --------------------------------------------------------------------
FROM docker.osgeo.org/geoserver:2.24.2

# ---------------------------------------------------------
# 🔧 Variáveis principais de ambiente
# ---------------------------------------------------------
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver \
    GEOSERVER_DATA_DIR=/usr/local/tomcat/webapps/geoserver/data_dir \
    PROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver \
    GEOSERVER_CSRF_DISABLED=true \
    DEFAULT_WORKSPACE=meu_workspace \
    JAVA_OPTS="-Xms512m -Xmx1024m -Djava.awt.headless=true \
    -DGEOSERVER_LOG_LOCATION=${GEOSERVER_DATA_DIR}/logs/geoserver.log \
    -Dorg.geotools.util.logging.Logging.ALL=true \
    -Dorg.geoserver.logging.LoggingUtils.level=FINE \
    -DGEOSERVER_VERBOSE=true \
    -DGEOSERVER_LOG_STDOUT=true"

# ---------------------------------------------------------
# 📂 Copiar estrutura do GeoServer
# ---------------------------------------------------------
# Pasta principal de dados, workspaces e estilos
COPY data_dir ${GEOSERVER_DATA_DIR}

# Ficheiros adicionais de interface
COPY data_dir/web/accessDenied.jsp ${GEOSERVER_DATA_DIR}/web/accessDenied.jsp
COPY web-inf/web.xml ${GEOSERVER_HOME}/WEB-INF/web.xml

# ---------------------------------------------------------
# 🧰 Criar logs e definir permissões corretas
# ---------------------------------------------------------
RUN mkdir -p ${GEOSERVER_DATA_DIR}/logs && \
    touch ${GEOSERVER_DATA_DIR}/logs/geoserver.log && \
    chmod -R 777 ${GEOSERVER_DATA_DIR} && \
    chmod -R 755 ${GEOSERVER_HOME}

# ---------------------------------------------------------
# 🌐 Porta padrão
# ---------------------------------------------------------
EXPOSE 8080

# ---------------------------------------------------------
# 🚀 Arranque do GeoServer
# ---------------------------------------------------------
CMD ["catalina.sh", "run"]
