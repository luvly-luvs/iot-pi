#!/usr/bin/env bash
set -xeou pipefail

chmod 745 ~

mkdir -m 745 ~/.aws-iot-device-client ~/.aws-iot-device-client/log
touch ~/.aws-iot-device-client/log/aws-iot-device-client.log ~/.aws-iot-device-client/log/sdk.log
chmod 600 ~/.aws-iot-device-client/log/*

mkdir -m 700 ~/certs ~/certs/device ~/certs/claim
curl -o ~/certs/AmazonRootCA1.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem
openssl req -new -newkey rsa:2048 -nodes -config ~/configs/device-csr.conf -keyout ~/certs/device/private.pem.key -out ~/certs/device/device.pem.csr
chmod 644 ~/certs/AmazonRootCA1.pem
chmod 600 ~/certs/device/* ~/certs/claim/*
# CSR might need 644 perms

chmod 745 ~/configs
chmod 644 ~/configs/*

[ ! -d "$HOME"/messages ] && mkdir -m 745 ~/messages
chmod 745 ~/messages/*

[ ! -d "$HOME"/jobs ] && mkdir -m 700 ~/jobs
chmod 700 ~/jobs/*
