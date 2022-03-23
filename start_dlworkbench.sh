# Script to launch openvino-workbench container
# OpenVINO DL Workbench Application accessed through web browser with http://<ec2-public-ip>:5665/

OV_VERSION=2022.1.0
# Remove any existing workbench container
docker rm workbench

# Start OpenVINO DL Workbench
/home/ec2-user/.local/bin/openvino-workbench \
        --image openvino/workbench:$OV_VERSION \
        --enable-authentication \
        --assets-directory /home/ec2-user/.workbench \
        >/tmp/ov-workbench.log 2>&1 &
