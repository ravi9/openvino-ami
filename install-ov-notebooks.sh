#!/bin/bash

# Script to install following on Amazon Linux 2 EC2 instance
# Intel OpenVINO (DEV) and its dependencies,
# Jupyter Lab
# Install OpenVINO_Notebooks https://github.com/openvinotoolkit/openvino_notebooks

# Install dependencies
sudo yum -y update &&
sudo yum -y upgrade &&
sudo yum -y groupinstall "Development Tools" &&
sudo yum install -y python3 python3-devel.x86_64 mesa-libGL

sudo ln -s /usr/bin/pip3 /usr/bin/pip

pip install --upgrade pip

pip install jupyterlab ipywidgets virtualenv

cd /home/ec2-user
git clone --depth=1 https://github.com/openvinotoolkit/openvino_notebooks.git
cd openvino_notebooks

pip install -r requirements.txt

# Install specific version of OPENCV
OPENCV_VER=4.5.5.64
pip install -U opencv-python-headless==$OPENCV_VER opencv-python==$OPENCV_VER

# Name the ipython kernel to OpenVINO
/usr/bin/python3 -m ipykernel install --user --name OpenVINO

# Download scripts to start Jupyter
curl https://raw.githubusercontent.com/psakamoori/scripts/main/start_jupyter.sh -o /home/ec2-user/.start_jupyter.sh

# Give executable permissions to the scripts
chmod 755 /home/ec2-user/.start_jupyter.sh

# Add cronjob to start jupyter on start of the instance.
curl https://raw.githubusercontent.com/psakamoori/scripts/main/add_cron_job.sh -o /home/ec2-user/.add_cron_job.sh

sudo bash /home/ec2-user/.add_cron_job.sh
