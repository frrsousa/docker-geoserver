# ---------------------------------------------------------------------
# Dockerfile otimizado para GeoServer 2.24.2 em ambiente Render (512 MB RAM)
# ---------------------------------------------------------------------

FROM docker.osgeo.org/geoserver:2.24.2

# Diretórios principais
ENV GEOSERVER_HOME=/opt/geoserver \
    GEOSERVER_DATA_DIR=/opt/geoserver_data \
    GEOWEBCACHE_CACHE_DIR=/opt/geoserver_data/gwc

# Ajuste de memória e desempenho (máx. 384 MB Heap)
ENV JAVA_OPTS="-Xms128m -Xmx384m -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1MaxNewSizePercent=40 -Duser.timezone=UTC -Djava.awt.headless=true"

# Copiar o diretório de dados (deve conter global.xml, web.xml, etc.)
COPY geoserver_data/ /opt/geoserver_data/

# Permissões completas para evitar erro de escrita no Render
RUN chmod -R 777 /opt/geoserver_data

# Expor porta padrão
EXPOSE 8080

# Comando para iniciar o Tomcat com GeoServer
CMD ["catalina.sh", "run"]
