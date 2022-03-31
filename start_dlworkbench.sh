# Script to launch openvino-workbench container
# OpenVINO DL Workbench Application accessed through web browser with http://<ec2-public-ip>:5665/

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

OV_DLW_VER=2022.1

# Remove any existing workbench container
docker rm workbench

# Start OpenVINO DL Workbench
/home/ec2-user/.local/bin/openvino-workbench \
        --image openvino/workbench:$OV_DLW_VER \
        --custom-token $INSTANCE_ID \
        --enable-authentication \
        --assets-directory /home/ec2-user/.workbench \
        >/tmp/ov-workbench.log 2>&1 &
