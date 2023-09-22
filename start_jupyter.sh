# Script to start Jupyter Notebook server with EC2 $INSTANCE_ID as the password

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# Save the EC2 Instance public ipv4 address. This is used in Access-OpenVINO-Workbench.ipynb
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 >/home/ec2-user/.public-ipv4.txt

# Setup the ec2-user environment
cd /home/ec2-user
source /home/ec2-user/.bashrc
source /home/ec2-user/openvino_env/bin/activate
export PATH=/home/ec2-user/openvino_env/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH
export TF_ENABLE_ONEDNN_OPTS=1

# Start Jupyter Notebook server with $INSTANCE_ID as the password
cd /home/ec2-user/openvino_notebooks

/home/ec2-user/openvino_env/bin/jupyter lab \
--no-browser \
--NotebookApp.allow_password_change=False \
--NotebookApp.token="$INSTANCE_ID" \
--ip 0.0.0.0 \
--port 8888 >/dev/null 2>&1 &

# For debugging
#--port 8888 >/tmp/jupyter.log 2>&1 &

