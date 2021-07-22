# script to launch openvino-workbench container
# Application accessed through webbrowser with http://ec2-public-ip:5665/

openvino-workbench --image openvino/workbench:2021.4 > /tmp/workbench.out 2>&1 &
