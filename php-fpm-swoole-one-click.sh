# Auth: Wanjo Chan
# Purpose: php swoole dl compile link php-fpm install quick sh
# Usage: wget -q https://github.com/wanjochan/misctools/raw/master/php-fpm-swoole-one-click.sh -O - | sh

echo WARNING: some dependence could be needed
echo sudo apt-get install -y autoconf g++ make openssl libssl-dev libcurl4-openssl-dev libcurl4-openssl-dev pkg-config

# TODO if args provided then use args --PHPVER, and also the PHPDL and target folder
PHPVER="7.0.8"
PHPDL="http://hk.php.net/distributions/"
mkdir $HOME/php7/
cd $HOME/php7/

PHPTGZ=php-${PHPVER}.tgz
if [ ! -f "$PHPTGZ" ]
then
wget http://hk1.php.net/distributions/php-$PHPVER.tar.gz -o $PHPTGZ
ls -al $PHPTGZ
tar xzvf $PHPTGZ
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

$HOME/opt/php7/bin/pecl uninstall swoole
$HOME/opt/php7/bin/pecl install swoole

(cat <<EOF
short_open_tag = On
#max_executionn_time=600
#memory_limit=512M
#error_reporting=1
#display_errors=0
log_errors=1
user_ini.filename=
realpath_cache_size=2M
cgi.check_shebang_line=0

zend_extension=opcache.so
opcache.enable_cli=1
opcache.save_comments=0
opcache.fast_shutdown=1
opcache.validate_timestamps=1
opcache.revalidate_freq=60
opcache.use_cwd=1
opcache.max_accelerated_files=100000
opcache.max_wasted_percentage=5
opcache.memory_consumption=128
opcache.consistency_checks=0

#for safety of php-fpm, @ref 
#https://help.aliyun.com/knowledge_detail/5994617.html
cgi.fix_pathinfo=0

extension=swoole.so

EOF
) > $HOME/opt/php7/lib/php.ini

alias php7='$HOME/opt/php7/bin/php'
alias php7-fpm='$HOME/opt/php7/sbin/php-fpm'

php7 -m
php7-fpm -m

