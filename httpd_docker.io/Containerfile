FROM docker.io/httpd:latest

MAINTAINER Jose Luis G.F.

# Copiamos la Web que se ha diseñado
COPY index.html /usr/local/apache2/htdocs/

# Copiamos .htaccess para definir que tiene Autenticación Basica 
COPY htaccess /usr/local/apache2/htdocs/.htaccess

# Copiamos htpasswd con la info del usuario y pw 
# credos para acceder a los recursos de la Web
COPY htpasswd /usr/local/apache2/.htpasswd

# Copiamos httpd.conf
COPY httpd.conf /usr/local/apache2/conf/

# Se copian el certificado y la clave generada por consola
# en la ubicación correcta para que se detecte por el servicio 
# y muestre en el navegador que tiene un certificado cargado aunque no sea valido

COPY practicadevops.local.key /usr/local/apache2/
COPY practicadevops.local.crt /usr/local/apache2/
