FROM tomcat:9.0.31-jdk11-openjdk

RUN rm -rf $CATALINA_HOME/webapps/*

ADD dist/geoserver.war /usr/local/tomcat/webapps/geoserver.war
ADD lib/jasypt-1.9.2.jar /lib/jasypt-1.9.2.jar
ADD dist/tomcat-lib/*.jar /usr/local/tomcat/lib
ADD context.xml /usr/local/tomcat/conf/context.xml

ADD dist/data_dir/ /opt/geoserver/data_dir_source/
RUN mkdir /opt/geoserver/data_dir/
ADD dist/prg/ /opt/geoserver/prg/

ADD scripts/ /scripts/
RUN chmod +x /scripts/*.sh

ENV \
    GEOSERVER_DATA_DIR=/opt/geoserver/data_dir \
    GEOSERVER_OPTS="-Ds3.properties.location=/opt/geoserver/s3.properties -Duser.timezone=GMT -Dit.geosolutions.skip.external.files.lookup=true"

CMD ["/scripts/entrypoint.sh"]
