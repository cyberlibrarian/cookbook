#!/bin/bash
### 
### This is intended to be used the user-data section of an AWS
### Launch Template. The script will install all the components
### needed to create a GPU-powered password cracking instance
###
### https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-nvidia-driver.html
###


# install kernel module build packages
sudo yum update -y
sudo yum install -y gcc kernel-devel-$(uname -r)

# Install the GRID drivers from AWS
#aws s3 cp --recursive s3://ec2-linux-nvidia-drivers/latest/ .
#chmod +x NVIDIA-Linux-x86_64*.run
#sudo /bin/sh ./NVIDIA-Linux-x86_64*.run

# Install the public NVIDIA Tesla T4 drivers
# Get the public NVIDIA drivers for Telsa T4 on CUDA 12
VERSION="525.105.17"
wget https://us.download.nvidia.com/tesla/${VERSION}/NVIDIA-Linux-x86_64-${VERSION}.run
chmod +x NVIDIA-Linux-x86_64-${VERSION}.run
sudo ./NVIDIA-Linux-x86_64-${VERSION}.run

# For NVIDIA driver version >= 14.x on G4dn instances, disable GSP
sudo touch /etc/modprobe.d/nvidia.conf
echo "options nvidia NVreg_EnableGpuFirmware=0" | sudo tee --append /etc/modprobe.d/nvidia.conf

# Set GPU clock speed to maxiumum on G4dn instances
sudo nvidia-smi -ac 5001,1590

# Reboot
sudo reboot
