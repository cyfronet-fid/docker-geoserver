#!/bin/bash

pushd $GEOSERVER_DATA_DIR

JDBCCONFIG_PATH=jdbcconfig/jdbcconfig.properties
mv $JDBCCONFIG_PATH $JDBCCONFIG_PATH.orig

cat $JDBCCONFIG_PATH.orig |
 sed -e "s/^enabled=.*$/enabled=${JDBCCONFIG_ENABLED:-false}/" |
 sed -e "s/^initdb=.*$/initdb=${JDBCCONFIG_INITDB}/" |
 sed -e "s/^import=.*$/import=${JDBCCONFIG_IMPORT}/" |
 sed -e "s/^jdbcUrl=.*$/jdbcUrl=${JDBCCONFIG_JDBC_URL}/" |
 sed -e "s/^username=.*$/username=${JDBCCONFIG_USERNAME}/" |
 sed -e "s/^password=.*$/password=${JDBCCONFIG_PASSWORD}/" > $JDBCCONFIG_PATH

rm $JDBCCONFIG_PATH.orig

popd
