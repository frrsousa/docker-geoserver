FROM tomcat:9.0.111-jdk17

ENV GEOSERVER_VERSION=2.24.2
ENV GEOSERVER_HOME=/usr/local/tomcat/webapps/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir

# Instalar wget e unzip
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Limpar e criar diretórios
RUN rm -rf ${GEOSERVER_HOME} && mkdir -p ${GEOSERVER_HOME} ${GEOSERVER_DATA_DIR}/logs

# Descarregar WAR oficial do GeoServer
RUN wget -O /tmp/geoserver.zip "https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download" && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war /tmp/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip

# Descompactar WAR dentro do GeoServer
RUN unzip /tmp/geoserver.war -d ${GEOSERVER_HOME} && rm /tmp/geoserver.war

# Remover conteúdos pesados desnecessários
RUN rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo

# Copiar data_dir completo
COPY data_dir ${GEOSERVER_DATA_DIR}

# Garantir logs vazios
RUN touch ${GEOSERVER_DATA_DIR}/logs/geoserver.log

# Expor porta padrão do Tomcat
EXPOSE 8080

# Definir diretório de trabalho
WORKDIR /usr/local/tomcat

# Definir variável para apontar data_dir
ENV CATALINA_OPTS="-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR}"

# Arrancar Tomcat
CMD ["catalina.sh", "run"]

