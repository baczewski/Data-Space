import subprocess

# TODO: To be implemented tomorrow
# TODO: Dynamically pass props to shell scripts (not a big problem)

"""
Steps to run it menually:
    You will need 4 terminals:

    On Terminal X run "./shell_scripts/build_connector.sh" to build the connectors
    On Terminal 1 run "./shell_scripts/run_connector_consumer.sh" to run the consumer
    On Terminal 2 run "./shell_scripts/run_connector_provider.sh" to run the provider
    On Terminal 3 run:
        "docker build -t http-request-logger util/http-request-logger"
        "docker run -p 4000:4000 http-request-logger"
    On Terminal X run "./gradlew transfer:transfer-03-consumer-pull:provider-proxy-data-plane:build"

    On Terminal X run "./shell_scripts/fetch_catalog_negotiate.sh" to set up contract negotiation
    On Terminal X run "./shell_scripts/transfer_provider_push.sh" to transfer the data to the provider

    On Terminal X run "./shell_scripts/fetch_catalog_negotiate.sh" to set up contract negotiation
    On Terminal X run "./shell_scripts/transfer_consumer_push.sh" to transfer the data to the consumer
"""

if __name__ == "__main__":
    pass
