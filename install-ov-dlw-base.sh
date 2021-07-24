# Script to install docker, intel openvino and DL Workbench on Amazon Linux 2 EC2 instance

# Install dependencies and Docker
sudo yum -y update &&
    sudo yum -y groupinstall "Development Tools" &&
    sudo amazon-linux-extras install -y docker &&
    sudo service docker start &&
    sudo usermod -aG docker ec2-user

# Install OpenVINO and DL-Workbench
sudo yum install -y python3 &&
    sudo yum install -y python3-devel.x86_64 &&
    pip3 install openvino-dev &&
    python3 -m pip install -U openvino-workbench

# Install this specific version of CV and uninstall to bypass libgl errors.
pip3 install -U opencv-python-headless==4.2.0.32 &&
    pip3 uninstall -y opencv-python

# Install Tensorflow, Pytorch, ONNX
pip3 install tensorflow -U
pip3 install torch -U
pip3 install onnx

# Pull Docker image - openvino/workbench:2021.4
sudo docker pull openvino/workbench:2021.4
