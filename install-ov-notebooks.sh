#!/bin/bash

# Script to install OpenVINO_Notebooks on Amazon Linux 2023 based EC2 instance
# OpenVINO_Notebooks: https://github.com/openvinotoolkit/openvino_notebooks

# Install dependencies
sudo yum -y update &&
sudo yum -y upgrade &&
sudo yum -y groupinstall "Development Tools" &&
sudo yum install -y git-all mesa-libGL cronie

# Enable and start the ‘cronie’ service. CronTab is  missing in AL 2023.
sudo systemctl enable crond.service
sudo systemctl start crond.service

# Create Python Virtual Env and install OV Notebooks
cd /home/ec2-user
source /home/ec2-user/.bashrc
python3 -m venv openvino_venv
source openvino_venv/bin/activate
export PATH=/home/ec2-user/openvino_venv/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH
git clone --depth=1 https://github.com/openvinotoolkit/openvino_notebooks.git
cd openvino_notebooks

# Install OpenVINO Notebook dependencies.
/home/ec2-user/openvino_venv/bin/pip install -r requirements.txt

# Clear pip cache
/home/ec2-user/openvino_venv/bin/pip cache purge

# Name the ipython kernel to OpenVINO
/home/ec2-user/openvino_venv/bin/python -m ipykernel install --user --name OpenVINO

# Download scripts to start Jupyter
curl https://raw.githubusercontent.com/ravi9/openvino-ami/main/start_jupyter.sh -o /home/ec2-user/.start_jupyter.sh

# Give executable permissions to the scripts
chmod 755 /home/ec2-user/.start_jupyter.sh

# Add cronjob to start jupyter on start of the instance.
curl https://raw.githubusercontent.com/ravi9/openvino-ami/main/add_cron_job.sh -o /home/ec2-user/.add_cron_job.sh

sudo bash /home/ec2-user/.add_cron_job.sh

# Verify  cronjobs
sudo crontab -l