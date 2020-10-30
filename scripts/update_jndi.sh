#!/bin/bash

CONTEXT_XML_PATH=/usr/local/tomcat/conf/context.xml

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
      --expression="s| $PARAM_NAME=\".*\"| $PARAM_NAME=\"$TARGET_VALUE\"|" \
      $CONTEXT_XML_PATH
}

update_param name                   JNDI_NAME                     "jdbc/sat4envi"
update_param url                    JNDI_URL
update_param username               JNDI_USERNAME
update_param password               JNDI_PASSWORD
update_param initialSize            JNDI_INITIAL_SIZE             "0"
update_param maxTotal               JNDI_MAX_TOTAL                "8"
update_param minIdle                JNDI_MIN_IDLE                 "0"
update_param maxIdle                JNDI_MAX_IDLE                 "8"
update_param maxWaitMillis          JNDI_MAX_WAIT_MILLIS          "10000"
update_param validationQueryTimeout JNDI_VALIDATION_QUERY_TIMEOUT "10"
