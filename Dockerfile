# Imagem base oficial do GeoServer
FROM docker.osgeo.org/geoserver:2.24.2

# =========================
# VARIÁVEIS DE AMBIENTE
# =========================
ENV GEOSERVER_HOME=/opt/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir
ENV PROXY_BASE_URL=https://docker-geoserver-qmk6.onrender.com/geoserver
ENV GEOSERVER_LOG_LOCATION=${GEOSERVER_DATA_DIR}/logs/geoserver.log
ENV JAVA_OPTS="-Xms512m -Xmx1024m -Djava.awt.headless=true -Dfile.encoding=UTF-8"

# =========================
# COPIAR CONFIGURAÇÕES
# =========================

# Copia a pasta de dados local (data_dir)
COPY data_dir ${GEOSERVER_DATA_DIR}

# Copia o ficheiro web.xml atualizado para o local correto
COPY data_dir/web/web.xml ${GEOSERVER_HOME}/webapps/geoserver/WEB-INF/web.xml

# Copia a página accessDenied.jsp (deve estar em data_dir/web/)
COPY data_dir/web/accessDenied.jsp ${GEOSERVER_DATA_DIR}/web/accessDenied.jsp

# =========================
# PERMISSÕES E CONFIGURAÇÃO
# =========================

# Garante permissões adequadas (Render pode usar utilizador restrito)
RUN chmod -R 755 ${GEOSERVER_HOME} && \
    chmod -R 755 ${GEOSERVER_DATA_DIR} && \
    mkdir -p ${GEOSERVER_DATA_DIR}/logs && \
    touch ${GEOSERVER_DATA_DIR}/logs/geoserver.log && \
    chown -R root:root ${GEOSERVER_HOME} ${GEOSERVER_DATA_DIR}

# =========================
# PORTA E STARTUP
# =========================

EXPOSE 8080

# Comando de inicialização
CMD ["catalina.sh", "run"]
