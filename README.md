# docker-geoserver

Based on kartoza/docker-geoserver, stripped down and modified to fit sat4envi requirements.

## Essentials

Versions:
- GeoServer 2.18.0,
- GeoTools 24.0 (patched),
- Tomcat 9.0.39.

Requirements:
- docker `^18.09.6`,
- [git lfs](https://git-lfs.github.com/).


## Building image

Pre-build the required files by running `./build.sh`.
It will build the GeoServer, extract the PRG archive and prepare GeoServer data_dir.

Then run `docker build .` to build the image.

When publishing the image, tag it when building with `docker build -t fiddev/geoserver:<version> .`.
And then `docker push fiddev/geoserver:<version>`.


## Running the image

To create a container run:
```shell
docker run \
    -e GEOSERVER_ADMIN_PASSWORD=<password> \
    -e S3_ENDPOINT="http://minio:9000/" \
    -e S3_ACCESS_KEY="minio" \
    -e S3_SECRET_KEY="minio123" \
    -e GWC_ENDPOINT="http://minio:9000" \
    -e GWC_AWS_ACCESS_KEY="minio" \
    -e GWC_AWS_SECRET_KEY="minio123" \
    -e JNDI_URL="jdbc:postgresql://db:5432/sat4envi" \
    -e JNDI_USERNAME="sat4envi" \
    -e JNDI_PASSWORD="sat4envi" \
    -v <path/to/data_dir>:/opt/geoserver/data_dir \
    -v <optionally/path/to/custom/cache/config.xml>:/opt/geoserver/s3-cache.xml \
    -e GEOSERVER_RUN_OPTS='-Xms1G -Xmx4G' \
    -p 8080:8080 -d <image-tag>
```

The default GeoServer user is 'admin' with password 'geoserver'.
It should be customized with `GEOSERVER_ADMIN_PASSWORD` as shown above.

Use `GEOSERVER_RUN_OPTS` to specify JVM options, such as memory requirements.

Data dir should be mounted.
In case it is empty, it will be initialized with a pre-built data_dir.
This template disables services other than WMS and doesn't contain any more data.

A default S3 cache is used, which is specified in s3-cache.xml.
It can be customized by mounting an alternative configuration under `/opt/geoserver/s3-cache.xml`.
In particular, GeoServer s3-geotiff module uses ehCache 2.10.3.

By default, GWC cache with S3 blob store is used for tile caching.
It requires a separate configuration from the scene data access (the envvars `GWC_*`)
and can be configured to use a local minio while scenes are loaded from Ceph.
It stores the data in `s4e-gwc` bucket (created automatically if doesn't exist) if not configured otherwise.


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
