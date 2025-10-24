# --------------------------------------------------------------------
# 🌍 GeoServer personalizado (Railway)
# Base: GeoServer 2.24.2 (Tomcat 9)
# --------------------------------------------------------------------
FROM docker.osgeo.org/geoserver:2.24.2

# ---------------------------------------------------------
# 🔧 Variáveis principais de ambiente
# ---------------------------------------------------------
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver \
    GEOSERVER_DATA_DIR=/opt/geoserver_data \
    PROXY_BASE_URL=https://docker-geoserver-production.up.railway.app/geoserver \
    GEOSERVER_CSRF_DISABLED=true \
    JAVA_OPTS="-Xms1024m -Xmx2048m -Djava.awt.headless=true \
    -DGEOSERVER_LOG_LOCATION=/opt/geoserver_data/logs/geoserver.log \
    -DPROXY_BASE_URL=https://docker-geoserver-production.up.railway.app/geoserver \
    -DGEOSERVER_CSRF_DISABLED=true"

# ---------------------------------------------------------
# 📂 Copiar estrutura de dados e configuração
# ---------------------------------------------------------
COPY data_dir ${GEOSERVER_DATA_DIR}
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
