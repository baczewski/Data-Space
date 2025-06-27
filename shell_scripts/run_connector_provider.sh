#!/bin/bash

PROVIDER_TYPE=$1

if [ -z "$PROVIDER_TYPE" ]; then
    echo "Error: use connetor provider as follows: ./run_connector_provider.sh {PROVIDER_TYPE}"
    exit 1
fi

java -Dedc.fs.config=transfer/transfer-03-consumer-pull/resources/configuration/provider.properties \
    -jar transfer/transfer-03-consumer-pull/provider-proxy-data-plane/build/libs/connector.jar