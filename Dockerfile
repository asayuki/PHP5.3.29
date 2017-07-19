FROM debian:jessie

COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-cache search php5 && apt-get install -y wget make bzip2 apache2 php5 php5-common php5-cli php5-mysql php5-gd php5-mcrypt php5-curl libapache2-mod-php5 php5-xmlrpc libapache2-mod-fastcgi build-essential php5-dev libbz2-dev libmysqlclient-dev libxpm-dev libmcrypt-dev libcurl4-gnutls-dev libxml2-dev libjpeg-dev libpng12-dev

RUN wget http://in1.php.net/distributions/php-5.3.29.tar.bz2 \
    && tar -xvf php-5.3.29.tar.bz2 \
    && cd php-* \ 
    && ./configure --prefix=/usr/share/php53 --datadir=/usr/share/php53 --mandir=/usr/share/man --bindir=/usr/bin/php53 --includedir=/usr/include/php53 --sysconfdir=/etc/php53/apache2 --with-config-file-path=/etc/php53/apache2 --with-config-file-scan-dir=/etc/php53/conf.d --enable-bcmath --with-curl=shared,/usr --with-mcrypt=shared,/usr --enable-cli --with-gd --with-mysql --with-mysqli --enable-libxml --enable-session --enable-xml --enable-simplexml --enable-filter --enable-inline-optimization --with-jpeg-dir --with-png-dir --with-zlib --with-bz2 --with-curl --enable-exif --enable-soap --with-pic --disable-rpath --disable-static --enable-shared --with-gnu-ld --enable-mbstring \
    && make \
    && make install \
    && cd .. \
    && rm php-5.3.29.tar.bz2 \
    && rm -r php-*

RUN a2enmod cgi fastcgi actions

COPY php53-cgi /usr/lib/cgi-bin/php53-cgi
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
COPY docker-apache2 /usr/local/bin
COPY index.php /var/www/public/index.php

RUN chmod +x /usr/lib/cgi-bin/php53-cgi
RUN chmod +x /usr/local/bin/docker-apache2
RUN service apache2 restart

EXPOSE 80

CMD ["/usr/local/bin/docker-apache2"]