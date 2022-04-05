#!/bin/bash

# Script to install following on Amazon Linux 2 EC2 instance
# Docker, 
# Jupyter Lab
# Intel OpenVINO (DEV) and its dependencies,
# OpenVINO DL Workbench,
# OpenVINO™ integration with TensorFlow (OVTF)

OV_VER=2022.1.0
OV_DLW_VER=2022.1.0

# Install dependencies, Install Python3.8
sudo yum -y update &&
    sudo yum -y groupinstall "Development Tools" &&
    sudo amazon-linux-extras enable python3.8 &&
    sudo yum -y install python38 python38-devel &&
    pip3.8 install --upgrade pip --user &&
    sudo ln -s /usr/bin/pip3.8 /usr/bin/pip
    

# Install Docker
sudo amazon-linux-extras install -y docker &&
    sudo systemctl enable docker &&
    sudo systemctl start docker &&
    sudo usermod -a -G docker ec2-user

# Install OpenVINO and DL-Workbench
    pip install jupyterlab progress tqdm matplotlib scipy ipykernel virtualenv &&
    pip install openvino-dev==$OV_VER &&
    pip install openvino-workbench==$OV_DLW_VER

# Install this specific version of CV and uninstall to bypass libgl errors.
pip install -U opencv-python-headless==4.2.0.32 &&
pip uninstall -y opencv-python

# Install Tensorflow, Pytorch, ONNX, MxNET
pip install tensorflow -U
pip install torch -U
pip install onnx -U
pip install mxnet -U

# Clear pip cache
pip cache purge

# Name the ipython kernel to OpenVINO 
/usr/bin/python3 -m ipykernel install --user --name OpenVINO

# Setup OpenVINO Workbench
# Pull Docker image - openvino/workbench:$OV_DLW_VER
sudo docker pull openvino/workbench:$OV_DLW_VER

#create folder for workbench assets, preserves work done in workbench 
mkdir -m 777 /home/ec2-user/.workbench

# Download scripts to start Jupyter and DL workbench.
curl https://raw.githubusercontent.com/psakamoori/scripts/main/start_jupyter.sh -o /home/ec2-user/.start_jupyter.sh

curl https://raw.githubusercontent.com/psakamoori/scripts/main/start_dlworkbench.sh -o /home/ec2-user/.start_dlworkbench.sh

# Give executable permissions to the scripts
chmod 755 /home/ec2-user/.start_jupyter.sh /home/ec2-user/.start_dlworkbench.sh

# Add cronjob to start jupyter and DL workbench on start of the instance.
curl https://raw.githubusercontent.com/psakamoori/scripts/main/add_cron_job.sh -o /home/ec2-user/.add_cron_job.sh

sudo bash /home/ec2-user/.add_cron_job.sh

# Download ipynb with instructions to retrieve DL workbench token.
curl https://raw.githubusercontent.com/psakamoori/scripts/main/Access-OpenVINO-Workbench.ipynb -o /home/ec2-user/Access-OpenVINO-Workbench.ipynb
