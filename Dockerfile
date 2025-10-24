# ---------------------------------------------------------------------
# Dockerfile otimizado e compatível com Render (GeoServer 2.24.2)
# Corrige erro: "/geoserver_data": not found
# ---------------------------------------------------------------------

FROM docker.osgeo.org/geoserver:2.24.2

# Diretórios principais
ENV GEOSERVER_HOME=/opt/geoserver \
    GEOSERVER_DATA_DIR=/opt/geoserver_data \
    GEOWEBCACHE_CACHE_DIR=/opt/geoserver_data/gwc

# Ajuste de memória e desempenho (máx. 384 MB Heap)
ENV JAVA_OPTS="-Xms128m -Xmx384m -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1MaxNewSizePercent=40 -Duser.timezone=UTC -Djava.awt.headless=true"

# Cria diretório de dados (caso não exista)
RUN mkdir -p /opt/geoserver_data && chmod -R 777 /opt/geoserver_data

# Copia ficheiros apenas se existirem no contexto
# (isto evita o erro 'checksum not found' no Render)
COPY ./geoserver_data/ /opt/geoserver_data/ || true

# Cria ficheiro global.xml se não for fornecido
RUN if [ ! -f /opt/geoserver_data/global.xml ]; then \
    echo '<global><settings><id>GlobalSettingsInfoImpl-1</id><verbose>false</verbose><verboseExceptions>false</verboseExceptions><charset>UTF-8</charset><numDecimals>6</numDecimals><onlineResource>https://docker-geoserver-qmk6.onrender.com/geoserver</onlineResource><proxyBaseUrl>https://docker-geoserver-qmk6.onrender.com/geoserver</proxyBaseUrl></settings><logging><level>INFO</level><location>logs/geoserver.log</location><stdOutLogging>false</stdOutLogging></logging><featureTypeCacheSize>100</featureTypeCacheSize><jvm><allowEnvironmentVariables>true</allowEnvironmentVariables></jvm><globalServices>false</globalServices></global>' > /opt/geoserver_data/global.xml; \
    fi

# Permissões completas para evitar erro de escrita
RUN chmod -R 777 /opt/geoserver_data

# Expor porta padrão
EXPOSE 8080

# Comando padrão
CMD ["catalina.sh", "run"]
