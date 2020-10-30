FROM tomcat:9.0.39-jdk11-openjdk

COPY dist/data_dir/ /opt/geoserver/data_dir_source/
RUN mkdir /opt/geoserver/data_dir/
COPY dist/prg/ /opt/geoserver/prg/
COPY s3-cache.xml /opt/geoserver/s3-cache.xml

COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

RUN rm -rf $CATALINA_HOME/webapps/*

COPY dist/geoserver.war /usr/local/tomcat/webapps/geoserver.war
COPY lib/jasypt-1.9.2.jar /lib/jasypt-1.9.2.jar
COPY dist/tomcat-lib/*.jar /usr/local/tomcat/lib
COPY context.xml /usr/local/tomcat/conf/context.xml

ENV \
    GEOSERVER_DATA_DIR=/opt/geoserver/data_dir \
    GEOSERVER_OPTS="-Ds3.properties.location=/opt/geoserver/s3.properties -Duser.timezone=GMT -Dit.geosolutions.skip.external.files.lookup=true -Ds3.caching.ehCacheConfig=/opt/geoserver/s3-cache.xml"

CMD ["/scripts/entrypoint.sh"]
