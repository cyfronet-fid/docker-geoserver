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
    maven:3.6.3-jdk-11 \
    mvn clean install -DskipTests -Ps3-geotiff

# Note that the GeoServer build depends on the GeoTools package, so the .m2 dir must contain the built artifacts
docker run -it --rm \
    -v "$HOME/.m2":/root/.m2 \
    -v $(pwd):/usr/src/docker-geoserver \
    -w /usr/src/docker-geoserver/geoserver/src \
    maven:3.6.3-jdk-11 \
    mvn clean package -DskipTests -Ps3-geotiff,gwc-s3 -T1C

rm -rf dist/
mkdir dist/

# Unpack the geoserver.war, move postgresql lib to tomcat lib dir and repack geoserver.war (for JNDI)
unzip geoserver/src/web/app/target/geoserver.war -d dist/geoserver
mkdir dist/tomcat-lib
mv dist/geoserver/WEB-INF/lib/postgresql-*.jar dist/tomcat-lib
pushd dist/geoserver
zip -r geoserver.war .
mv geoserver.war ..
popd
rm -rf dist/geoserver

mkdir dist/data_dir
cp -r geoserver/data/minimal/* dist/data_dir
cp -r geoserver/data/release/security dist/data_dir

pushd dist/data_dir
rm -rf workspaces/*
rm styles/*
disable_services csw.xml wcs.xml wfs.xml
popd

cp -r data_dir_contents/* dist/data_dir

pushd dist
docker run -it --rm \
    -v $(pwd)/../data/prg.7z:/data/prg.7z \
    -v $(pwd):/target/ \
    -w /target/ \
    crazymax/7zip \
    7za x /data/prg.7z
popd
