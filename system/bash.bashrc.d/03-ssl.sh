#!/usr/bin/env bash
# This just exposes ssl config properties to the environment.

# The main ssl cert locations.
export SSL_CERT_DIR='/etc/ssl/certs'
export SSL_CERT_FILE="${SSL_CERT_DIR}/ca-certificates.crt"

# Application-specific config.
export CURL_CA_BUNDLE="${SSL_CERT_FILE}"
export NODE_EXTRA_CA_CERTS="${SSL_CERT_DIR}"
export REQUESTS_CA_BUNDLE="${SSL_CERT_FILE}"

