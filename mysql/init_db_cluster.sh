export SVRT_PORT=$*
if [ "" = "$SVRT_PORT" ]
then
	echo init_db need SVRT_PORT
	exit
fi



#ls $SVRT_SOFT
sed "s#^lc-messages-dir\s*=.*#lc-messages-dir=$SVRT_SOFT/usr/share/mysql#g" -i  $SVRT_SOFT/etc/mysql/mysql.conf.d/mysqld.cnf
ls -al $SVRT_SOFT/usr/bin/mysqld_safe

# quick test 1
#$SVRT_SOFT/usr/bin/mysqld_safe --version

# quick test 2
$SVRT_SOFT/usr/sbin/mysqld --no-defaults \
--lc-messages-dir=$SVRT_SOFT/usr/share/mysql \
--socket=$SVRT_RUN/mysql$SVRT_PORT.sock \
--datadir=/data/data$SVRT_PORT/datadir/ \
--secure-file-priv=$SVRT_RUN \
--user=$USER --explicit_defaults_for_timestamp \
--verbose --version

echo init db...
# source env.sh 9394
mkdir -p /data/data$SVRT_PORT
#rm -rf /data/data$SVRT_PORT/datadir/
$SVRT_SOFT/usr/sbin/mysqld --no-defaults \
--lc-messages-dir=$SVRT_SOFT/usr/share/mysql \
--socket=$SVRT_RUN/mysql$SVRT_PORT.sock \
--datadir=/data/data$SVRT_PORT/datadir/ \
--initialize-insecure --user=$USER --explicit_defaults_for_timestamp
ls -al /data/data$SVRT_PORT/datadir/


