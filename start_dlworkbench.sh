# Script to launch openvino-workbench container
# Application accessed through webbrowser with http://<ec2-public-ip>:5665/

# Remove any existing workbench container
docker rm workbench

# Start OpenVINO DL Workbench
/home/ec2-user/.local/bin/openvino-workbench --image openvino/workbench:2021.4 >/tmp/ov-workbench.log 2>&1 &
