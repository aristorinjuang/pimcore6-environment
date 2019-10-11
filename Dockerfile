FROM ubuntu:18.04
LABEL maintainer="Aristo Rinjuang <aristorinjuang@gmail.com>"
RUN apt-get update
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 80
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y php7.2
RUN apt-get install -y php7.2-common
RUN apt-get install -y php7.2-fpm
RUN apt-get install -y php7.2-mysql
RUN apt-get install -y php7.2-iconv
RUN apt-get install -y php7.2-dom
RUN apt-get install -y php7.2-gd
RUN apt-get install -y php7.2-exif
RUN apt-get install -y php7.2-imagick
RUN apt-get install -y php7.2-mbstring
RUN apt-get install -y php7.2-zip
RUN apt-get install -y php7.2-intl
RUN apt-get install -y php7.2-opcache
RUN apt-get install -y php7.2-curl
RUN apt-get install -y php7.2-json
RUN apt-get install -y php7.2-xsl
RUN apt-get install -y php7.2-redis
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini
RUN apt-get install -y supervisor
ADD supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /run/php
RUN chown -R www-data:www-data /var/www
RUN chown -R www-data:www-data /run/php
ADD start.sh /start.sh
CMD ["./start.sh"]