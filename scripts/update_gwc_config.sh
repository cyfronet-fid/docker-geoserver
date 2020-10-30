#!/bin/bash

GWC_XML_PATH=$GEOSERVER_DATA_DIR/gwc/geowebcache.xml

update_param() {
  PARAM_NAME=$1
  PARAM_ENV_NAME=$2
  DEFAULT_VALUE=$3
  if [ -n "${!PARAM_ENV_NAME}" ]; then
    TARGET_VALUE=${!PARAM_ENV_NAME}
  else
    TARGET_VALUE=$DEFAULT_VALUE
  fi
  sed --in-place \
      --expression="s|<$PARAM_NAME>.*</$PARAM_NAME>|<$PARAM_NAME>$TARGET_VALUE</$PARAM_NAME>|" \
      $GWC_XML_PATH
}

update_param bucket       GWC_BUCKET         "s4e-gwc"
update_param awsAccessKey GWC_AWS_ACCESS_KEY
update_param awsSecretKey GWC_AWS_SECRET_KEY
update_param access       GWC_ACCESS         "private"
update_param useHTTPS     GWC_USE_HTTPS      `[[ $GWC_ENDPOINT = "https"* ]] && echo true || echo false`
update_param endpoint     GWC_ENDPOINT
update_param useGzip      GWC_USE_GZIP       "true"
