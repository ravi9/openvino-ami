# Script to install docker, intel openvino and DL Workbench on Amazon Linux 2 EC2 instance

OV_VERSION=2021.4.2

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

# Create openvino_tensorflow ipython kernel
/usr/bin/python3 -m virtualenv /home/ec2-user/.ovtf-venv
source /home/ec2-user/.ovtf-venv/bin/activate
pip install ipykernel
pip install tensorflow==2.5.1
pip install -U openvino-tensorflow
python3 -m ipykernel install --user --name openvino_tensorflow
deactivate

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
