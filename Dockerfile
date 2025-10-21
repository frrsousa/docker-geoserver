FROM tomcat:9-jdk17

ENV GEOSERVER_DATA_DIR=/opt/geoserver/data_dir
ENV PORT=8080
ENV JAVA_OPTS="-Xms256m -Xmx480m -XX:+UseG1GC"

# Criar utilizador e pasta de dados
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat
RUN mkdir -p ${GEOSERVER_DATA_DIR} && chown -R tomcat:tomcat ${GEOSERVER_DATA_DIR}

# Instalar GeoServer core
ADD https://sourceforge.net/projects/geoserver/files/GeoServer/2.27.2/geoserver-2.27.2-war.zip /tmp/geoserver.zip
RUN unzip /tmp/geoserver.zip -d /tmp/ && \
    mv /tmp/geoserver.war /usr/local/tomcat/webapps/geoserver.war && \
    rm -rf /tmp/*

EXPOSE 8080

CMD ["sh", "-c", "sleep 20 && catalina.sh run -Dport.http=$PORT"]

