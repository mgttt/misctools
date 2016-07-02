# Auth: Wanjo Chan
# Purpose: php swoole dl compile link php-fpm install quick sh
# Usage: wget -q https://github.com/wanjochan/misctools/raw/master/php-fpm-swoole-one-click.sh -O - | sh

# TODO if args provided then use args --PHPVER, and also the PHPDL and target folder
PHPVER="7.0.8"
PHPDL="http://hk.php.net/distributions/"
mkdir $HOME/php7/
cd $HOME/php7/

PHPTGZ=php-${PHPVER}.tgz
if [ ! -f "$PHPTGZ" ]
then
wget http://hk1.php.net/distributions/php-$PHPVER.tar.gz -O $PHPTGZ
ls -al php-${PHPVER}.tgz
tar xzvf php-$PHPVER.tar.gz
fi

cd php-$PHPVER/

# TODO more PHPCONF 
./configure \
--prefix=$HOME/opt/php7 \
--enable-fpm \
--enable-opcache \
--with-openssl \
--with-system-ciphers \
--with-zlib \
--with-curl \
--with-pcre-dir \
--with-pcre-regex \
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
