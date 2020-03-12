#!/bin/bash

export JAVA_OPTS="${JAVA_OPTS} ${GEOSERVER_OPTS} ${GEOSERVER_RUN_OPTS}"

# copy the source data_dir if the used $GEOSERVER_DATA_DIR is empty
pushd $GEOSERVER_DATA_DIR
if [[ "$(ls -A .)"='' ]]; then
    cp -r ../data_dir_source/* .
fi
popd

/scripts/update_passwords.sh
/scripts/update_jndi.sh
/usr/local/tomcat/bin/catalina.sh run
