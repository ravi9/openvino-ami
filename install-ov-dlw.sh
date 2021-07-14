# Script to install docker, intel openvino and DL Workbench on Amazon Linux 2 EC2 instance

sudo yum update -y && sudo yum groupinstall "Development Tools" &&
sudo amazon-linux-extras install docker && sudo service docker start && sudo usermod -a -G docker ec2-user

sudo yum install python3 && sudo yum install python3-devel.x86_64 && pip3 install -U opencv-python-headless==4.2.0.32 && pip3 install openvino-python && python3 -m pip install -U openvino-workbench




