export SVRT_PORT=$*
if [ "" = "$SVRT_PORT" ]
then
	echo source env.sh XXXX
	exit
fi

#$SVRT_SOFT/etc/mysql/mysql.conf.d/mysqld.cnf

$SVRT_SOFT/usr/bin/mysqld_safe --no-defaults \
--socket=$SVRT_RUN/mysql$SVRT_PORT.sock \
--datadir=/data/data$SVRT_PORT/datadir/ \
--secure-file-priv=$SVRT_RUN \
-P $((SVRT_PORT+1)) \
--user=$USER --explicit_defaults_for_timestamp
