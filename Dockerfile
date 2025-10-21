FROM tomcat:9.0.111-jdk17

# Copiar GeoServer Lite
COPY webapps/geoserver /usr/local/tomcat/webapps/geoserver

# Expor porta HTTP
EXPOSE 8080

# Arrancar Tomcat
CMD ["catalina.sh", "run"]
