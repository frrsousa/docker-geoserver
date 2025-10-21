# --------------------------
# Dockerfile leve para Render Free
# GeoServer core apenas, para WMS
# --------------------------

FROM tomcat:9-jdk17

# Variáveis de ambiente
ENV GEOSERVER_DATA_DIR=/opt/geoserver/data_dir
ENV PORT=8080
ENV JAVA_OPTS="-Xms256m -Xmx480m -XX:+UseG1GC"

# Criar diretório de dados (permissões abertas)
RUN mkdir -p ${GEOSERVER_DATA_DIR} && chmod -R 777 ${GEOSERVER_DATA_DIR}

# Instalar curl (necessário para download do WAR)
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Baixar WAR direto do GeoServer
WORKDIR /usr/local/tomcat/webapps
RUN curl -L -o geoserver.war "https://sourceforge.net/projects/geoserver/files/GeoServer/2.27.2/geoserver-2.27.2-war.zip/download"

# Expor porta do Render
EXPOSE 8080

# Arranque com delay para evitar timeout no Render
CMD ["sh", "-c", "sleep 20 && catalina.sh run -Dport.http=$PORT"]
