#!/bin/bash

#1. Instalar tomcat
# Actualizar el sistema de ubuntu
apt update -y
apt upgrade -y

# Instalar Java JDK (17)
apt install openjdk-17-jdk
apt install openjdk-17-jre

# Crear usuario y grupo tomcat de no existir
if id "tomcat" >/dev/null 2>&1; then
        echo "Usuario tomcat ya existe"
else
        useradd -m -d /opt/tomcat -U -s /bin/false tomcat
fi

# Descargar Apache Tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz

# Crear directorio de instalación para tomcat
mkdir -p /opt/tomcat

# Descomprimir Apache Tomcat en el directorio creado
tar xzvf apache-tomcat-10.1.18.tar.gz -C /opt/tomcat --strip-components=1

# Cambiar propietario y permisos del directorio de instalación. Necesario para el funcionamiento de tomcat
chown -R tomcat:tomcat /opt/tomcat

chmod -R u+x /opt/tomcat/bin

#2. Tomcat necesita configurar usuarios y administradores para su funcionamiento:
# Introducimos dichos roles y usuarios en tomcat-users.xml
sed -i '/<\/tomcat-users>/i \ <role rolename="manager-gui" \/>\n <user username="manager" password="manager_password" roles="manager-gui" \/>\n <role rolename="admin-gui" \/>\n <user username="admin" password="admin_password" roles="manager-gui,admin-gui" \/>' /opt/tomcat/conf/tomcat-users.xml

# Quitamos las restricciones por defecto de tomcat
# Comentar la etiqueta Valve en context.xml es necesario
sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/, /allow="127\\.\d+\\.\d+\\.\d+\|::1\|0:0:0:0:0:0:0:1" \/>/ s/^/<!-- /; s/$/ -->/' /opt/tomcat/webapps/manager/META-INF/context.xml

# Comentar la misma etiqueta en host-manager
sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/, /allow="127\\.\d+\\.\d+\\.\d+\|::1\|0:0:0:0:0:0:0:1" \/>/ s/^/<!-- /; s/$/ -->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml

# 3. Creamos el servicio de tomcat
# Crear el archivo tomcat.service y añadimos el contenido
sudo bash -c 'cat > /etc/systemd/system/tomcat.service' <<-'EOF'
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Obtener la ruta de instalación de nuestro Java 17.0
JAVA_PATH=$(sudo update-java-alternatives -l | grep '1.17.0' | awk '{print $3}')

# Reemplazar JAVA_HOME en tomcat.service
sudo sed -i "s|JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64|JAVA_HOME=$JAVA_PATH|g" /etc/systemd/system/tomcat.service

# Recargamos los  servicios systemd y habilitamos Apache Tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat