#!/usr/bin/env bash
set -xeou pipefail

sudo apt-get -y update
sudo apt-get -y install build-essential libssl-dev cmake unzip git python3-pip

git clone https://github.com/awslabs/aws-iot-device-client aws-iot-device-client

mkdir -m 745 aws-iot-device-client/build
cd aws-iot-device-client/build

cmake ../
cmake --build . --target aws-iot-device-client

./aws-iot-device-client --help
./aws-iot-device-client --version
