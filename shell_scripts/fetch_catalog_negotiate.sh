#!/bin/bash

# PORT=$1
# PROVIDER=$2
# CONSUMER=$3

PORT=29193 # this is consumer's http.management.port
PROVIDER=hospital
CONSUMER=lab

policy_id=$(curl -s -X POST "http://localhost:$PORT/management/v3/catalog/request" \
  -H 'Content-Type: application/json' \
  -d @transfer/transfer-01-negotiation/resources/fetch-catalog-$PROVIDER.json \
  | jq -r '.["dcat:dataset"]["odrl:hasPolicy"]["@id"]')

echo "Policy ID: $policy_id"

template_file="transfer/transfer-01-negotiation/resources/negotiate-contract-$PROVIDER-$CONSUMER.json"
output_file="transfer/transfer-01-negotiation/resources/negotiate-contract-$PROVIDER-$CONSUMER-v1.json"

sed "s/{placeholder}/$policy_id/g" "$template_file" > "$output_file"

contract_negotiation_id=$(curl -d @transfer/transfer-01-negotiation/resources/negotiate-contract-$PROVIDER-$CONSUMER-v1.json \
  -X POST -H 'content-type: application/json' http://localhost:$PORT/management/v3/contractnegotiations \
  -s | jq -r '.["@id"]')

echo "Contract Negotiation ID: $contract_negotiation_id"

sleep 10

contract=$(curl -X GET "http://localhost:$PORT/management/v3/contractnegotiations/${contract_negotiation_id}" \
    --header 'Content-Type: application/json' \
    -s | jq .)

echo "Contract ID: ${contract}"

echo "$contract" >> contract.txt

rm -f "${output_file}"
