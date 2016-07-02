# php swoole dl compile link php-fpm install quick sh
# php-fpm-swoole-one-click.sh

PHPVER="7.0.8"
PHPDL="http://hk.php.net/distributions/"
mkdir $HOME/php7/
cd $HOME/php7/
wget http://hk1.php.net/distributions/php-$PHPVER.tar.gz -o php-${PHPVER}.tgz
ls -al php-${PHPVER}.tgz
tar xzvf php-$PHPVER.tar.gz
cd php-$PHPVER/


./configure \
--prefix=$HOME/opt/php7 \
--enable-opcache \
--with-openssl \
--with-system-ciphers \
--with-zlib \
--with-curl \
--with-pcre-dir \
--enable-ftp \
--with-zlib-dir \
--with-mysqli \
--with-mysql-sock \
--with-zlib-dir \
--enable-embedded-mysqli \
--with-pdo-mysql \
--enable-soap \
--enable-sockets \
--enable-zip \
--enable-mysqlnd \
--with-pear

make && make install

# swoole

$HOME/opt/php7/bin/pear config-set download_dir $HOME/php7/
$HOME/opt/php7/bin/pear config-set temp_dir $HOME/php7/

$HOME/opt/php7/bin/pecl install swoole
