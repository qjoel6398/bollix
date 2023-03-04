## DEVELOPMENT
### Remoting in to a GPU-enabled Linux box:
modifying https://cloud.google.com/architecture/creating-a-virtual-gpu-accelerated-linux-workstation tutorial.

#### 1. Start VM, install drivers, and set up x2goserver. Replace <personal-access-token> with personal access token from github.
  
```
gcloud compute instances create bollix-1 \
    --machine-type n1-highmem-4 \
    --accelerator type=nvidia-tesla-p4-vws,count=1 \
    --can-ip-forward \
    --maintenance-policy "TERMINATE" \
    --tags "https-server" \
    --image-project ubuntu-os-cloud \
    --image-family ubuntu-1804-lts \
    --boot-disk-size 50GB \
    --zone us-central1-a
```

* more powerful option:

```
gcloud compute instances create bollix-1 \
    --machine-type custom-24-32768 \
    --accelerator type=nvidia-tesla-p4-vws,count=1 \
    --can-ip-forward \
    --maintenance-policy "TERMINATE" \
    --tags "https-server" \
    --image-project ubuntu-os-cloud \
    --image-family ubuntu-1804-lts \
    --boot-disk-size 100 \
    --zone us-central1-a
```
#### 3. sign in to VMS and change user password

`gcloud compute ssh bollix-1 --project=superb-watch-220203 --zone=us-central1-a`

`` sudo passwd `whoami` ``

#### 4. install desktop env on remote (ubuntu)

`sudo apt-get update`
  
`sudo apt-get install xubuntu-desktop -y`

`sudo reboot`

#### 5. install NVIDIA drivers

List drivers:
`gsutil ls gs://nvidia-drivers-us-public/GRID`

Install Driver Dependencies:
* change this depending on specs used. for now:

`sudo apt-get install gcc -y`
`sudo apt-get install make -y`
`sudo apt-get install pkg-config libglvnd-dev -y`

Install Driver:
`curl -O \
https://storage.googleapis.com/nvidia-drivers-us-public/GRID/GRID11.1/NVIDIA-Linux-x86_64-450.80.02-grid.run`
  
`sudo bash NVIDIA-Linux-x86_64-450.80.02-grid.run --compat32-libdir=/usr/lib32`
  
If you're prompted to install 32-bit binaries, choose Yes.
If you're prompted to modify the x.org file, choose No.

test with:

`nvidia-smi`


#### 6. set up X2GO server (ubuntu)
##### Install x2go on server (https://wiki.archlinux.org/title/X2Go#Server_side): 

`sudo apt-get install x2goserver x2goserver-xsession`

`sudo systemctl enable x2goserver`  

`sudo systemctl start x2goserver`  

`sudo systemctl status x2goserver`  

##### configure x11 forwarding:

```
sudo sed -i 's/#X11Forwarding no/X11Forwarding yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
sudo sed -i 's/X11UseLocalhost yes/#X11UseLocalhost yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#X11DisplayOffset 10/X11DisplayOffset 10/g' /etc/ssh/sshd_config
sudo systemctl restart ssh
sudo systemctl enable ssh
```

##### set  firewall rules for X2GO:
`sudo ufw allow 22/tcp`

##### start x2go db:
`sudo x2godbadmin --createdb`

#### 2. set up X2GO client:
##### Download x2go client: https://wiki.x2go.org/doku.php/download:start

##### Log in using ssh public/private key pair:
1. generate public private key pair with something like `ssh-keygen -t rsa -C "qjoel6398"`

2. add public key to gce metadata: https://cloud.google.com/compute/docs/connect/add-ssh-keys#metadata
configure x2go client connection using hostname and private key path.
 * remember that keys have usernames so make sure you are using the correct username.

  
### Installing and setting up Unity:
  
1. Start session on GCE instance
2. Follow install instructions on https://unity.com/
3. Open with `unityhub` command


 ISSUE:
    Unity is crashing when trying to start my project template.
      - Problem with Graphics card drivers/dependencies? 
         - note terminal output of `unityhub` on VM. ChatGPT says it's an issue with OpenGL library /GLX  which is likely a driver mismatch.
          - note Unity Editor logs:` home/qjoel6398/.config/unity3d/Editor.log`
         - research graphics card and driver requirements for Unity on Ubuntu. 
      - problem with desktop environment compatability?
          - How would I find compatability requirements here?
      - general approach for handling crash error on UnityHub?
      * - you might need to start from scratch with the VM setup, leave NVIDIA drivers until last.
      * - last tried:
  
          ```
        apt install nvidia-cuda-toolkit
        sudo add-apt-repository ppa:graphics-drivers/ppa
        sudo apt-get update
        sudo apt-get install nvidia-driver-470
        sudo reboot
        ```
        
  
  
