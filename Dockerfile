# ────────────────────────────────────────────────
# GeoServer Lite – otimizado para Render (512 MB)
# ────────────────────────────────────────────────
FROM tomcat:9.0.111-jdk17

# Versão e paths principais
ENV GEOSERVER_VERSION=2.24.2
ENV CATALINA_HOME=/usr/local/tomcat
ENV GEOSERVER_HOME=${CATALINA_HOME}/webapps/geoserver
ENV GEOSERVER_DATA_DIR=${GEOSERVER_HOME}/data_dir
ENV JAVA_OPTS="-Xms128m -Xmx384m -Djava.awt.headless=true"

# Instalar dependências mínimas
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Limpar diretórios anteriores (caso existam)
RUN rm -rf ${GEOSERVER_HOME} && mkdir -p ${GEOSERVER_HOME}

# ────────────────────────────────────────────────
# Descarregar e instalar o WAR oficial do GeoServer
# ────────────────────────────────────────────────
RUN wget -O /tmp/geoserver.zip \
    https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download && \
    unzip /tmp/geoserver.zip -d /tmp/geoserver && \
    mv /tmp/geoserver/geoserver.war /tmp/geoserver.war && \
    rm -rf /tmp/geoserver /tmp/geoserver.zip && \
    unzip /tmp/geoserver.war -d ${GEOSERVER_HOME} && \
    rm /tmp/geoserver.war

# ────────────────────────────────────────────────
# Remover conteúdos desnecessários
# ────────────────────────────────────────────────
RUN rm -rf ${GEOSERVER_HOME}/doc ${GEOSERVER_HOME}/demo ${GEOSERVER_HOME}/gwc

# ────────────────────────────────────────────────
# Copiar o data_dir mínimo
# ────────────────────────────────────────────────
COPY data_dir ${GEOSERVER_DATA_DIR}

# Garantir permissões adequadas (evita erro 400)
RUN chmod -R 755 ${GEOSERVER_HOME} && \
    chown -R root:root ${GEOSERVER_HOME}

# ────────────────────────────────────────────────
# Definir variáveis no contexto Tomcat
# ────────────────────────────────────────────────
# Isto garante que o GeoServer reconhece o data_dir correto
ENV CATALINA_OPTS="-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR}"

# ────────────────────────────────────────────────
# Configurar Tomcat e porta
# ────────────────────────────────────────────────
EXPOSE 8080
WORKDIR ${CATALINA_HOME}

# ────────────────────────────────────────────────
# Arrancar Tomcat
# ────────────────────────────────────────────────
CMD ["catalina.sh", "run"]
