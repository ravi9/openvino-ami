#!/bin/bash

# Test script which tests: OpenVINO Python imports.

# Path where all the pip-installed OpenVINO binaries
BIN_PREFIX=/home/ec2-user/openvino_env/bin/

## Test Python Imports

$BIN_PREFIX/python -c "import openvino as ov; print('OpenVINO Version: ' + ov.runtime.get_version())"

$BIN_PREFIX/python -c "from openvino.tools.benchmark.main import main"
