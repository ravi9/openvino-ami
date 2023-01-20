# Add cronjob to start jupyter and DL workbench on start of the instance.
(
    crontab -l 2>/dev/null
    echo "@reboot su ec2-user -c \"/home/ec2-user/.start_jupyter.sh\" "
) | crontab -
