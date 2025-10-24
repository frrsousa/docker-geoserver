FROM docker.osgeo.org/geoserver:2.24.2

# Definir variáveis de ambiente básicas
ENV GEOSERVER_HOME=/opt/geoserver \
    GEOSERVER_DATA_DIR=/opt/geoserver_data \
    GEOWEBCACHE_CACHE_DIR=/opt/geoserver_data/gwc \
    JAVA_OPTS="-Xms128m -Xmx384m -XX:+UseG1GC -Duser.timezone=UTC -Djava.awt.headless=true"

# Copiar o diretório de dados (se existir no repositório)
COPY geoserver_data/ /opt/geoserver_data/

# Garantir permissões adequadas
RUN chmod -R 777 /opt/geoserver_data

# Expor a porta padrão do GeoServer
EXPOSE 8080

# Iniciar o GeoServer
CMD ["catalina.sh", "run"]


