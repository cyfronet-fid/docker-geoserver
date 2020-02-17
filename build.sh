#!/bin/bash

disable_services(){
    while (($#)); do
        SERVICE_CONFIG_FILE=$1
        cat $SERVICE_CONFIG_FILE | sed -e "s/<enabled>true/<enabled>false/" > $SERVICE_CONFIG_FILE.tmp
        mv $SERVICE_CONFIG_FILE.tmp $SERVICE_CONFIG_FILE
        shift
    done
}

docker run -it --rm \
    -v "$HOME/.m2":/root/.m2 \
    -v $(pwd):/usr/src/docker-geoserver \
    -w /usr/src/docker-geoserver/geotools \
    maven:3.6.2-jdk-11 \
    mvn clean install -DskipTests -Ps3-geotiff

# Note that the GeoServer build depends on the GeoTools package, so the .m2 dir must contain the built artifacts
docker run -it --rm \
    -v "$HOME/.m2":/root/.m2 \
    -v $(pwd):/usr/src/docker-geoserver \
    -w /usr/src/docker-geoserver/geoserver/src \
    maven:3.6.2-jdk-11 \
    mvn clean package -DskipTests -Ps3-geotiff -Pjdbcconfig

rm -rf dist/
mkdir dist/

mkdir dist/data_dir
cp -r geoserver/data/minimal/* dist/data_dir
cp -r geoserver/data/release/security dist/data_dir

JDBCCONFIG_RESOURCES_PATH=geoserver/src/community/jdbcconfig/src/main/resources
mkdir -p dist/data_dir/jdbcconfig/scripts
cp $JDBCCONFIG_RESOURCES_PATH/jdbcconfig.properties dist/data_dir/jdbcconfig
cp $JDBCCONFIG_RESOURCES_PATH/org/geoserver/jdbcconfig/internal/*.postgres.sql dist/data_dir/jdbcconfig/scripts

pushd dist/data_dir
rm -rf workspaces/*
rm styles/*
disable_services csw.xml wcs.xml wfs.xml
popd

pushd dist
docker run -it --rm \
    -v $(pwd)/../data/prg.7z:/data/prg.7z \
    -v $(pwd):/target/ \
    -w /target/ \
    crazymax/7zip \
    7za x /data/prg.7z
popd
