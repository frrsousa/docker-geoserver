# Base Tomcat leve
FROM tomcat:9-jdk17

# Variáveis de ambiente
ENV GEOSERVER_DATA_DIR=/opt/geoserver/data_dir
ENV PORT=8080
ENV JAVA_OPTS="-Xms256m -Xmx480m -XX:+UseG1GC"

# Criar pasta de dados
RUN mkdir -p ${GEOSERVER_DATA_DIR} && chown -R tomcat:tomcat ${GEOSERVER_DATA_DIR}

# Copiar WAR do GeoServer core (sem plugins)
ADD https://sourceforge.net/projects/geoserver/files/GeoServer/2.27.2/geoserver-2.27.2-war.zip /tmp/geoserver.zip
RUN unzip /tmp/geoserver.zip -d /tmp/ && \
    mv /tmp/geoserver.war /usr/local/tomcat/webapps/geoserver.war && \
    rm -rf /tmp/*

# Expor porta do Render
EXPOSE 8080

# Arranque com delay para evitar timeout no Render
CMD ["sh", "-c", "sleep 20 && catalina.sh run -Dport.http=$PORT"]
