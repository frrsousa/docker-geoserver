# Imagem base estável do GeoServer
FROM geoserver/geoserver:2.24.2

# Define variáveis de ambiente essenciais
ENV GEOSERVER_DATA_DIR=/opt/geoserver/data_dir \
    GEOSERVER_LOG_LOCATION=/opt/geoserver/data_dir/logs/geoserver.log \
    JAVA_OPTS="-Xms512m -Xmx1g -Djava.awt.headless=true -Dfile.encoding=UTF-8"

# Copia o diretório de dados preparado localmente
COPY data_dir /opt/geoserver/data_dir

# Garante que o diretório de logs existe (sem necessidade de chmod)
RUN mkdir -p /opt/geoserver/data_dir/logs && \
    touch /opt/geoserver/data_dir/logs/geoserver.log && \
    chown -R root:root /opt/geoserver/data_dir && \
    echo "Estrutura de dados copiada com sucesso."

# Define permissões compatíveis com o Render (sem comandos diretos)
RUN find /opt/geoserver/data_dir -type d -exec chmod 755 {} \; && \
    find /opt/geoserver/data_dir -type f -exec chmod 644 {} \;

# Define o diretório de trabalho
WORKDIR /opt/geoserver

# Expõe a porta padrão do GeoServer
EXPOSE 8080

# Define o comando de arranque
CMD ["sh", "-c", "exec /usr/local/tomcat/bin/catalina.sh run"]
