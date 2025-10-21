# Dockerfile Render Free usando Kartoza GeoServer
FROM kartoza/geoserver:2.27.2

# Define o diretório de dados (opcional)
ENV GEOSERVER_DATA_DIR=/opt/geoserver/data_dir

# Expor a porta usada pelo Render
EXPOSE 8080

# Arranque padrão do GeoServer
CMD ["catalina.sh", "run"]
