# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Support for JNDI based JDBC connection

### Changed

- Tomcat is updated to 9.0.31

## [1.2.0-GS2.16.2]

### Changed

- GeoServer version to 2.16.2
- GeoTools version to a patched 22.2 from https://github.com/cyfronet-fid/geotools (installed to local mvn repo `build.sh`)

### Fixed

- Disable scanning for overview files (*.ovr) by imagemosaic by setting `it.geosolutions.skip.external.files.lookup=true`
  GeoServer property
- Set timezone of GeoServer to GMT

[unreleased]: https://github.com/cyfronet-fid/docker-geoserver/compare/v1.2.0-GS2.16.2...HEAD
[1.2.0-GS2.16.2]: https://github.com/cyfronet-fid/docker-geoserver/compare/1.1.0-GS2.16.0...v1.2.0-GS2.16.2