#!/bin/bash

# Script to install following on Amazon Linux 2 EC2 instance
# Intel OpenVINO (DEV) and its dependencies,
# Jupyter Lab

OV_VER=2022.3.0

# Install dependencies and Docker
sudo yum -y update &&
sudo yum -y groupinstall "Development Tools"

sudo ln -s /usr/bin/pip3 /usr/bin/pip

# Install Python 3, Pip, Jupyterlab, OpenVINO and dependencies
sudo yum install -y python3 &&
    sudo yum install -y python3-devel.x86_64 &&
    pip install --upgrade pip &&
    pip install jupyterlab ipywidgets progress tqdm matplotlib scipy ipykernel virtualenv &&
    pip install openvino-dev[pytorch,tensorflow2,onnx,mxnet]==$OV_VER

# Install this specific version of CV and uninstall to bypass libgl errors.
pip install -U opencv-python-headless==4.2.0.32 &&
pip uninstall -y opencv-python

# Clear pip cache
pip cache purge

# Name the ipython kernel to OpenVINO
/usr/bin/python3 -m ipykernel install --user --name OpenVINO

# Download scripts to start Jupyter
curl https://raw.githubusercontent.com/psakamoori/scripts/$OV_VER/start_jupyter.sh -o /home/ec2-user/.start_jupyter.sh

# Give executable permissions to the scripts
chmod 755 /home/ec2-user/.start_jupyter.sh

# Add cronjob to start jupyter on start of the instance.
curl https://raw.githubusercontent.com/psakamoori/scripts/$OV_VER/add_cron_job.sh -o /home/ec2-user/.add_cron_job.sh

sudo bash /home/ec2-user/.add_cron_job.sh
