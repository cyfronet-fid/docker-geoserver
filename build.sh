#!/bin/bash

disable_services(){
    while (($#)); do
        SERVICE_CONFIG_FILE=$1
        cat $SERVICE_CONFIG_FILE | sed -e "s/<enabled>true/<enabled>false/" > $SERVICE_CONFIG_FILE.tmp
        mv $SERVICE_CONFIG_FILE.tmp $SERVICE_CONFIG_FILE
        shift
    done
}

# Add option below to use local maven cache (speeds up build)
#    -v "$HOME/.m2":/root/.m2 \
docker run -it --rm \
    -v "$HOME/.m2":/root/.m2 \
    -v $(pwd):/usr/src/docker-geoserver \
    -w /usr/src/docker-geoserver/geoserver/src \
    maven:3.6.1-jdk-11 \
    mvn clean package -DskipTests -Ps3-geotiff

rm -rf dist/
mkdir dist/

mkdir dist/data_dir
cp -r geoserver/data/minimal/* dist/data_dir
cp -r geoserver/data/release/security dist/data_dir

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
