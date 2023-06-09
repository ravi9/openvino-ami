#!/bin/bash

# Test script which tests: omz_downloader, omz_converter, benchmark_app, mo, OpenVINO Python imports.

# Path where all the pip-installed OpenVINO binaries
BIN_PREFIX=/home/ec2-user/.local/bin/

# Download googlenet-v1-tf model from OpenVINO Model Zoo (OMZ)
$BIN_PREFIX/omz_downloader --name googlenet-v1-tf

# Convert googlenet-v1-tf model to OpenVINO IR
$BIN_PREFIX/omz_converter --name googlenet-v1-tf

# Benchmark googlenet-v1-tf model with OpenVINO Benchmark App...¶
$BIN_PREFIX/benchmark_app -m public/googlenet-v1-tf/FP32/googlenet-v1-tf.xml -niter 1

# Test with model optimizer
$BIN_PREFIX/mo \
    --framework=tf \
    --data_type FP32 \
    --output_dir ./public/googlenet-v1-tf/FP32 \
    --model_name=googlenet-v1-tf \
    --input_shape=[1,224,224,3] \
    --input_model ./public/googlenet-v1-tf/inception_v1.frozen.pb

## Test Python Imports

python3 -c "from openvino.runtime import Core, get_version as get_ov_version; print('openvino version: ' + get_ov_version())"

python3 -c "from openvino.tools.benchmark.main import main"
