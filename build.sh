#!/usr/bin/env bash
# shellcheck disable=SC2164
set -xeou pipefail

(
  cd ./pi-gen
  ./build.sh
)
