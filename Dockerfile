FROM ubuntu:18.04
LABEL maintainer="Aristo Rinjuang <aristorinjuang@gmail.com>"
RUN apt-get update
RUN apt-get install -y sudo
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y libssl-dev
RUN apt-get install -y build-essential
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y unzip
RUN apt-get install -y uuid-dev
RUN apt-get install -y nano
RUN apt-get install -y imagemagick
RUN apt-get install -y graphviz
RUN curl https://raw.githubusercontent.com/pagespeed/ngx_pagespeed/master/scripts/build_ngx_pagespeed.sh --output build_ngx_pagespeed.sh
RUN chmod +x build_ngx_pagespeed.sh
RUN ./build_ngx_pagespeed.sh --nginx-version=latest
RUN sed -i "18i include /usr/local/nginx/conf.d/*.conf;\n" /usr/local/nginx/conf/nginx.conf
RUN echo "user www-data;" >> /usr/local/nginx/conf/nginx.conf
RUN echo "daemon off;" >> /usr/local/nginx/conf/nginx.conf
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
RUN echo "memory_limit = 2G\n" >> /etc/php/7.2/fpm/php.ini
RUN echo "upload_max_filesize = 128M\n" >> /etc/php/7.2/fpm/php.ini
RUN echo "post_max_size = 128M\n" >> /etc/php/7.2/fpm/php.ini
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN set -eux; \
    composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative; \
    composer clear-cache
ENV PATH="${PATH}:/root/.composer/vendor/bin"
RUN apt-get install -y supervisor
ADD supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /run/php
RUN mkdir -p /usr/local/nginx/conf.d
RUN mkdir -p /var/cache/ngx_pagespeed
RUN usermod -u 1000 www-data && usermod -G staff www-data
RUN chown -R www-data:www-data /var/cache/ngx_pagespeed
RUN chown -R www-data:www-data /var/www
RUN chown -R www-data:www-data /run/php
ADD start.sh /start.sh
CMD ["./start.sh"]