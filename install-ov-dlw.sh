# Script to install docker, intel openvino and DL Workbench on Amazon Linux 2 EC2 instance

# Install dependencies and Docker
sudo yum -y update && 
sudo yum -y groupinstall "Development Tools" &&
sudo amazon-linux-extras install -y docker && 
sudo service docker start && 
sudo usermod -a -G docker ec2-user

# Install OpenVINO and DL-Workbench
sudo yum install -y python3 && 
sudo yum install -y python3-devel.x86_64 &&
pip3 install -U opencv-python-headless==4.2.0.32 &&
pip3 install openvino-dev && 
pip3 install -U openvino-workbench




