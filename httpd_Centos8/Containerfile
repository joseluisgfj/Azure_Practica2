# Definimos la imagen que deseamos usar, en este caso Centos 8
FROM centos:8

# Definimos el creador del container
MAINTAINER José Luis G.F.

# Modificamos los repositorios dado que los que vienen por defecto ya no existen
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Instalamos el Apache (httpd) y el resto de servicios que necesitaremos 
RUN yum -y install httpd mod_ssl
RUN yum -y install httpd-tools
RUN yum -y install openssl
RUN yum clean all -y

# Copiamos en nuestro contenedor los diferentes archivos de configuración, 
# para que tengamos Autenticación básica y un certificado autofirmado
COPY index.html /var/www/html/
COPY httpd.conf /etc/httpd/conf/
COPY htpasswd /var/www/html/.htpasswd
COPY htaccess /var/www/html/.htaccess
COPY ssl.conf /etc/httpd/conf.d/

# Creamos una ruta y copiamos el certificado y la clave de nuestro certificado autofirmado
RUN mkdir /etc/ssl/private/
COPY practicadevops.local.key /etc/ssl/private/
COPY practicadevops.local.crt /etc/ssl/certs/

# Modificamos los permisos y los Owner de los archivos
RUN chown apache:apache /var/www/html/.htaccess
RUN chown apache:apache /var/www/html/.htpasswd
RUN chmod 644 /var/www/html/.htaccess /var/www/html/.htpasswd

# Modificamos los permisos del certificado y su clave
RUN chmod 644 /etc/ssl/certs/practicadevops.local.crt
RUN chmod 600 /etc/ssl/private/practicadevops.local.key

# Activamos para que corra la aplicación como servicio en el arranque 
RUN systemctl enable httpd.service

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

# Definimos el puerto que se expone
EXPOSE 8080

CMD ["/usr/sbin/init"]
