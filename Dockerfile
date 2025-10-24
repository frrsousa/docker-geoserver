# --------------------------------------------------------------------
# 🌍 GeoServer personalizado para Render (modo debug)
# Base: GeoServer 2.24.2 (Tomcat 9)
# --------------------------------------------------------------------
FROM docker.osgeo.org/geoserver:2.24.2

# ---------------------------------------------------------
# 🔧 Variáveis principais de ambiente
# ---------------------------------------------------------
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver \
    GEOSERVER_DATA_DIR=/opt/geoserver_data \
    PROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver \
    GEOSERVER_CSRF_DISABLED=true \
    DEFAULT_WORKSPACE=meu_workspace \
    JAVA_OPTS="-Xms512m -Xmx1024m -Djava.awt.headless=true \
    -DGEOSERVER_LOG_LOCATION=/opt/geoserver_data/logs/geoserver.log \
    -DPROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver \
    -Dorg.geotools.util.logging.Logging.ALL=true \
    -Dorg.geoserver.logging.LoggingUtils.level=FINE \
    -DGEOSERVER_CSRF_DISABLED=true \
    -DGEOSERVER_VERBOSE=true \
    -DGEOSERVER_LOG_STDOUT=true"

# ---------------------------------------------------------
# 📂 Copiar estrutura do GeoServer
# ---------------------------------------------------------
# Data dir completo (inclui global.xml, workspaces, styles, logs)
COPY data_dir ${GEOSERVER_DATA_DIR}

# Interface de erros
COPY data_dir/web/accessDenied.jsp ${GEOSERVER_DATA_DIR}/web/accessDenied.jsp

# Configuração do Tomcat para web.xml
COPY web-inf/web.xml ${GEOSERVER_HOME}/WEB-INF/web.xml

# ---------------------------------------------------------
# 🧰 Criar logs e permissões
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
