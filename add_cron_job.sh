(crontab -l; echo "@reboot su ec2-user -c /home/ec2-user/.start_jupyter.sh" ) | crontab -
