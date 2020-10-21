# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.5.0-GS2.18.0]

### Changed

- Enable S3 cache by default
- Disable advanced projection handling
- Update tomcat to 9.0.39 and GeoServer to 2.18.0

## [1.4.0-GS2.17.0]

### Changed

- Tomcat is updated to 9.0.34
- Control S3 properties (endpoint, access key and secret key) from envvars

## [1.3.0-GS2.16.2]

### Added

- Support for JNDI based JDBC connection

### Changed

- Tomcat is updated to 9.0.31

### Removed

- JDBCConfig support

## [1.2.0-GS2.16.2]

### Changed

- GeoServer version to 2.16.2
- GeoTools version to a patched 22.2 from https://github.com/cyfronet-fid/geotools (installed to local mvn repo `build.sh`)

### Fixed

- Disable scanning for overview files (*.ovr) by imagemosaic by setting `it.geosolutions.skip.external.files.lookup=true`
  GeoServer property
- Set timezone of GeoServer to GMT

[unreleased]: https://github.com/cyfronet-fid/docker-geoserver/compare/v1.5.0-GS2.18.0...HEAD
[1.5.0-GS2.18.0]: https://github.com/cyfronet-fid/docker-geoserver/compare/v1.4.0-GS2.17.0..v1.5.0-GS2.18.0
[1.4.0-GS2.17.0]: https://github.com/cyfronet-fid/docker-geoserver/compare/v1.3.0-GS2.16.2...v1.4.0-GS2.17.0
[1.3.0-GS2.16.2]: https://github.com/cyfronet-fid/docker-geoserver/compare/v1.2.0-GS2.16.2...v1.3.0-GS2.16.2
[1.2.0-GS2.16.2]: https://github.com/cyfronet-fid/docker-geoserver/compare/1.1.0-GS2.16.0...v1.2.0-GS2.16.2
