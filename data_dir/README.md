🌍 GeoServer Lite – Deploy no Render

Este repositório contém uma versão leve do GeoServer, pronta para ser executada gratuitamente no Render.com, utilizando Tomcat e um data_dir mínimo (sem dados de exemplo).

🚀 Estrutura do Repositório
├── Dockerfile
├── README.md
└── data_dir/
    ├── global.xml
    ├── logging.xml
    ├── security/
    │   ├── users.xml
    │   ├── roles.xml
    │   └── security.xml
    └── workspaces/
        └── default/
            ├── workspace.xml
            └── namespace.xml

🧱 Dockerfile

O Dockerfile usa uma imagem oficial do GeoServer disponível no Docker Hub, e copia o data_dir personalizado:

FROM docker.osgeo.org/geoserver:2.25.2

# Copiar configuração mínima
COPY data_dir /opt/geoserver_data_dir

EXPOSE 8080

⚙️ Deploy no Render

Faz fork ou upload deste repositório para a tua conta GitHub.

Vai a https://render.com
 e cria um novo Web Service.

Seleciona este repositório GitHub.

Nas opções:

Environment: Docker

Port: 8080

Plano gratuito (512 MB) é suficiente.

Aguarda a build e inicia o serviço.

🌐 Aceder ao GeoServer

Quando o Render indicar que o serviço está ativo, acede ao endereço:

https://<teu-serviço>.onrender.com/geoserver


🔑 Credenciais padrão:

Utilizador: admin

Senha: geoserver

🧩 Sobre o data_dir

O data_dir incluído é minimalista:

Sem dados de exemplo do GeoServer;

Autenticação básica;

Workspace chamado default;

Log simplificado (INFO).

Podes adicionar novas configurações, layers ou serviços WMS/WFS após o login.

🧰 Testar Localmente (opcional)

Se quiseres testar o GeoServer Lite no teu computador:

docker build -t geoserver-lite .
docker run -p 8080:8080 geoserver-lite


Depois abre no navegador:
http://localhost:8080/geoserver

📜 Licença

Este repositório segue a GNU GPL v2
, a mesma licença do projeto GeoServer
