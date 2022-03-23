#!/bin/bash

# Script to install following on Amazon Linux 2 EC2 instance
# Docker, 
# Jupyter Lab
# Intel OpenVINO (DEV) and its dependencies,
# OpenVINO DL Workbench,
# OpenVINO™ integration with TensorFlow (OVTF)

OV_VERSION=2022.1.0

# Install dependencies and Docker
sudo yum -y update &&
    sudo yum -y groupinstall "Development Tools" &&
    sudo amazon-linux-extras install -y docker &&
    sudo systemctl enable docker &&
    sudo systemctl start docker &&
    sudo usermod -a -G docker ec2-user

sudo ln -s /usr/bin/pip3 /usr/bin/pip

# Install OpenVINO and DL-Workbench
sudo yum install -y python3 &&
    sudo yum install -y python3-devel.x86_64 &&
    pip install --upgrade pip &&
    pip install jupyterlab progress tqdm matplotlib scipy ipykernel virtualenv &&
    pip install openvino-dev==$OV_VERSION &&
    pip install openvino-workbench==$OV_VERSION

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

# Install OpenVINO™ integration with TensorFlow (OVTF) as IPython Kernel

# Create openvino_tensorflow virtual env, which can be added as IPython Kernel
/usr/bin/python3 -m virtualenv /home/ec2-user/.ovtf-venv

# Activate ovtf-venv virtual env
source /home/ec2-user/.ovtf-venv/bin/activate

# Setup required versions
TF_VER=2.7.0
KERAS_VER=2.7.0
OVTF_VER=1.1.0
TF_ENABLE_ONEDNN_OPTS=1

pip install ipykernel
pip install tensorflow==$TF_VER keras==$KERAS_VER
pip install openvino_tensorflow==$OVTF_VER
# Create openvino_tensorflow ipython kernel
python3 -m ipykernel install --user --name openvino_tensorflow
deactivate

# OVTF IPython Kernel install ends.

# Setup OpenVINO Workbench
# Pull Docker image - openvino/workbench:$OV_VERSION
sudo docker pull openvino/workbench:$OV_VERSION

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
