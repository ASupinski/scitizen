#!/bin/bash

mkdir -pv build
zip -r build/v4mars.zip * -x "build/" "build.sh" "common.sh" "deploy.sh" "post-deploy.py" "int-tests.sh"