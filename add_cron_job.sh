(crontab -l; echo "@reboot su ec2-user $(/home/ec2-user/start_jupyter.sh)"; $(sudo systemctl start docker); $(/home/ec2-user/start_dlw.sh)) | crontab -
