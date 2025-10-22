FROM tomcat:9.0.111-jdk17

# Variável com ID do ficheiro do Google Drive
ENV FILE_ID="1qFt0uIuK0aVz60kVK-rm07zo_vH3sYFa"

# Instalar wget e unzip
RUN apt-get update && apt-get install -y wget unzip

# Download do WAR do Google Drive
UN wget --no-check-certificate "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O /tmp/geoserver.war

# Descompactar o WAR dentro do Tomcat
RUN mkdir -p /usr/local/tomcat/webapps/geoserver && \
    unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver && \
    rm /tmp/geoserver.war

# Expor porta HTTP
EXPOSE 8080

# Arrancar Tomcat
CMD ["catalina.sh", "run"]
