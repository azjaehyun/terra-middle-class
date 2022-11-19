#!/bin/bash

touch /etc/environment

if [ -z "${HTTP_PROXY}" ]; then
    echo "http_proxy=${HTTP_PROXY}" >> /etc/environment
    echo "HTTP_PROXY=${HTTP_PROXY}" >> /etc/environment
fi

if [ -z "${HTTPS_PROXY}" ]; then
    echo "https_proxy=${HTTPS_PROXY}" >> /etc/environment
    echo "HTTPS_PROXY=${HTTPS_PROXY}" >> /etc/environment
fi

if [ -z "${NO_PROXY}" ]; then
    echo "no_proxy=${NO_PROXY}" >> /etc/environment
    echo "NO_PROXY=${NO_PROXY}" >> /etc/environment
fi