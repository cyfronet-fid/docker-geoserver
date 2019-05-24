# docker-geoserver

Based on kartoza/docker-geoserver, stripped down and modified to fit sat4envi requirements.

## Essentials

Versions:
- GeoServer 2.15.1,
- Tomcat 9.

Requirements:
- docker `^18.09.6`,
- [git lfs](https://git-lfs.github.com/).


## Building image

Pre-build the required files by running `./build.sh`.
It will build the GeoServer, extract the PRG archive and prepare GeoServer data_dir.

Then run `docker build .` to build the image.


## Running the image

To create a container run:
```shell
docker run \
    -e GEOSERVER_ADMIN_PASSWORD=<password> \
    -v <path/to/s3.properties>:/opt/geoserver/s3.properties \
    -v <path/to/data_dir>:/opt/geoserver/data_dir \
    -e GEOSERVER_RUN_OPTS='-Xms1G -Xmx4G' \
    -p 8080:8080 -d <image-tag>
```

The default GeoServer user is 'admin' with password 'geoserver'.
It should be customized with `GEOSERVER_ADMIN_PASSWORD` as shown above.

Use `GEOSERVER_RUN_OPTS` to specify JVM options, such as memory requirements.

It is also necessary to mount `s3.properties` file with S3 endpoint configuration.

Data dir should be mounted as well.
In case it is empty, it will be initialized with a pre-built data_dir.
This template disables services other than WMS and doesn't contain any more data.


### Giving GeoServer access to s3.properties file

GeoServer will try to look for the s3-geotiff configuration in `/opt/geoserver/s3.properties`.
Mount a volume pointing to a local `s3.properties` file by adding `-v
</path/to/s3.properties>:/opt/geoserver/s3.properties` to docker run options.


## Version scheme

The release versions should follow the scheme `{MAJOR}.{MINOR}.{PATCH}-GS{GS-VERSION}`, for example `1.0.0-GS2.15.1`.


## Updating GeoServer version

To update the GeoServer version, `cd geoserver`, `git fetch` to get the current references
and `git checkout {GS-VERSION}`.
Then go back to root directory, stage the changes and commit.

The built image should now have updated GeoServer.


## Credits

The kartoza/docker-geoserver developers:
* Tim Sutton (tim@kartoza.com)
* Shane St Clair (shane@axiomdatascience.com)
* Alex Leith (alexgleith@gmail.com)
* Admire Nyakudya (admire@kartoza.com)
