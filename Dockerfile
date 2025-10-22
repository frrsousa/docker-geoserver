# Usar Tomcat 9 com JDK17
FROM tomcat:9.0.111-jdk17

# Variável para o ID do ficheiro Google Drive
ARG GEOSERVER_WAR_ID=1qFt0uIuK0aVz60kVK-rm07zo_vH3sYFa

# Criar pasta geoserver (Lite)
RUN mkdir -p /usr/local/tomcat/webapps/geoserver

# Baixar WAR do Google Drive para a pasta webapps
# Nota: substituir SEU_FILE_ID pelo ID real do ficheiro
RUN curl -L -o /usr/local/tomcat/webapps/geoserver.war "https://drive.google.com/uc?export=download&id=${GEOSERVER_WAR_ID}"

# Expor porta HTTP
EXPOSE 8080

# Arrancar Tomcat
CMD ["catalina.sh", "run"]
