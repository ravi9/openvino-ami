# Intel OpenVINO™ AMI Setup

This project provides scripts and configuration to build an AWS EC2 AMI (Amazon Machine Image) with [OpenVINO™](https://docs.openvino.ai/2025/index.html) Toolkit and OpenVINO™ Notebooks pre-installed. This allows you to quickly launch EC2 instances with a ready-to-use environment for OpenVINO™ development and experimentation.
- [Intel OpenVINO™ on AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-sa76mydxmlmwk)

## What are OpenVINO™ Notebooks?

[OpenVINO™ Notebooks](https://github.com/openvinotoolkit/openvino_notebooks) are a collection of ready-to-run Jupyter notebooks for learning and experimenting with the OpenVINO™ Toolkit. They provide an introduction to OpenVINO™ basics and teach developers how to leverage its API for optimized deep learning inference.

## Features

*   **Automated Installation:** Scripts automate the installation of OpenVINO™ Notebooks and all necessary dependencies.
*   **EC2 Image Builder Integration:** Designed to be used with AWS EC2 Image Builder for creating standardized AMIs.
*   **Jupyter Ready:** A Jupyter Notebook server is configured to start automatically when an EC2 instance launched from the AMI boots up.
*   **Pre-configured Environment:** Provides a virtual environment with OpenVINO™ and its Python libraries ready to use.

## Getting Started / Usage

This project is primarily intended to be used with [AWS EC2 Image Builder](https://aws.amazon.com/image-builder/). The `ec2builder-component.yaml` file defines an Image Builder component that automates the setup process.

1.  **Build an AMI:** Use the `ec2builder-component.yaml` (and optionally `ec2builder-test-component.yaml` for testing) with EC2 Image Builder to create your custom AMI.
2.  **Launch an Instance:** Launch a new EC2 instance from the AMI created in the previous step.
3.  **Access Jupyter Notebooks:** Once the instance is running, you can access the Jupyter Notebook server by opening your web browser and navigating to `http://<your-ec2-instance-public-ip>:8888`.
    *   You might need to configure your EC2 instance's security group to allow inbound traffic on port 8888.

## Manual Instance Setup and AMI Creation

While this project is designed for EC2 Image Builder, you can also use the provided scripts to manually set up an EC2 instance and create an AMI. The general steps would involve:

1.  Launch a base Amazon Linux 2023 instance.
2.  Copy the scripts from this repository to the instance.
3.  Run `install-ov-notebooks.sh` as the `ec2-user` to install OpenVINO Notebooks and its dependencies.
4.  (Optional) Run `test-pip-ov-install.sh` to verify the installation.
5.  Before creating an AMI from this manually configured instance, you need to run the `perform_cleanup` script (or ensure equivalent cleanup steps are performed) to remove instance-specific data. For more details, see [AWS EC2 Image Builder Security Best Practices](https://docs.aws.amazon.com/imagebuilder/latest/userguide/security-best-practices.html).
6.  Creating an AMI from the cleaned instance via the AWS Management Console or AWS CLI.

This approach gives you more control over the individual steps but requires manual execution.

## Scripts

This repository contains the following scripts:

*   **`install-ov-notebooks.sh`**: This is the main script executed by the EC2 Image Builder component. It performs the following actions:
    *   Installs system dependencies.
    *   Creates a Python virtual environment.
    *   Clones the OpenVINO™ Notebooks repository.
    *   Installs Python dependencies for the notebooks.
    *   Sets up an IPython kernel named "OpenVINO".
    *   Downloads scripts to start Jupyter and configure a cron job.
*   **`start_jupyter.sh`**: This script starts the Jupyter Notebook server. It's configured to run on instance startup.
*   **`add_cron_job.sh`**: This script creates a cron job that runs `start_jupyter.sh` automatically when the EC2 instance boots.
*   **`test-pip-ov-install.sh`**: This script performs a basic test to verify that OpenVINO™ Python packages are installed correctly and can be imported. It is typically used in the validation phase of the EC2 Image Builder pipeline.
*   **`perform_cleanup`**: This script contains functions to clean up various log files and instance-specific data. It is automatically invoked by AWS EC2 Image Builder as a security best practice to sanitize the instance before AMI creation. For more details, see [AWS EC2 Image Builder Security Best Practices](https://docs.aws.amazon.com/imagebuilder/latest/userguide/security-best-practices.html).


## EC2 Builder Components

*   **`ec2builder-component.yaml`**: This is the main component definition for EC2 Image Builder. It defines the build and validate phases for installing OpenVINO™ Notebooks.
*   **`ec2builder-test-component.yaml`**: This component is used for testing the OpenVINO™ installation, by running the `test-pip-ov-install.sh` script during the validation phase of the EC2 Image Builder pipeline.
