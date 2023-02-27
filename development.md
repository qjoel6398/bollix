# BOLLIX: 


## PLAN
Overview: Open up the app and it will show your camera pointing at a pool table, overlaying best shots in AR.

- [ ] 1. Set up Unity AR-Core/AR-Kit and development environment. Likely Cloud GPU machine on Google Cloud or AR-CORE.
- [ ] 2. Build plane detection system for pool table.
  - [ ] 2.1 Use unity AR's built-in plane detection
  - [ ] 2.2 Match from the list of detected planes using expected pool table dimensions.
  - [ ] 2.3 calculate location of pockets from pool table plane.
  - [ ] 2.4 extra validation if needed.
- [ ] 3. ball detection system.
  - [ ] 3.1 Train a pool ball segmentation model in TensorFlow-Lite. Make sure it collects all balls, along with ball number.
  - [ ] 3.2 use TensorFlow Lite Converter to get trained model into format for TensorFlowSharp (import TensorFlowSharp plugin in unity)
  - [ ] 3.3 use trained model to collect ball boundaries and numbers.
  - [ ] 3.4 map object in image to ground position.
- [ ] 4. Build Pool Cue object
  - [ ] 4.1 object that has trajectory, power, and english
  - [ ] 4.2 maps to 3d-model that displays each of these attributes on table, along with model of the actual pool cue.
- [ ] 5. build shot calculator
  - [ ] 5.1 ball-level shot calculator: use ball-level information (ball location, pocket, walls, geometry, english) to create a simplified pool physics calculator for single shot. Needs a rating system for shot difficulty. Returns pool cue object.
  - [ ] 5.2 table-level shot calculator: use table-level information (next few shots) to iterate through shot calculator and select best shot on table.
  - [ ] 5.3 shot-explorer: floating trajectory is given on arbitrary pool cue positions based on user input, balls and walls.
- [ ] 7. Allow pool cue to be interacted with user input.
- [ ] 8. User interactivity:
  - [ ] 8.0 table and balls are detected
  - [ ] 8.1 when table is clicked on, table-level shot calculator is run, Pool Cue is overlayed.
  - [ ] 8.2 when ball is clicked on, ball-level shot calculator is calculated, Pool Cue is overlayed.
  - [ ] 8.3when cue is dragged, shot-explorer is calculated, Pool Cue is overlayed.

Requirements:
1. Performant; Make sure renderer and detector is lightweight
2. Monetizable; Make sure you can resell while using built-in object detection, etc.

Other Features:
  1. Training setups. ie. 30 degree line system for setting up shots. etc.

## DEVELOPMENT
### Remoting in to a GPU-enabled Linux box
modifying https://cloud.google.com/architecture/creating-a-virtual-gpu-accelerated-linux-workstation tutorial.

#### 1. Enable compute engine API
#### 2. Create compute engine instance:
* note the "zone" flag. By default, you have unlimited quota for GPUS in certain zones.

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

`sudo apt-get install xubuntu-desktop`

`sudo reboot`

#### 5. install NVIDIA drivers

list drivers:
`gsutil ls gs://nvidia-drivers-us-public/GRID`

Install Driver:
* change this depending on specs used. for now:

```
curl -O \
https://storage.googleapis.com/nvidia-drivers-us-public/GRID/GRID11.1/NVIDIA-Linux-x86_64-450.80.02-grid.run
sudo bash NVIDIA-Linux-x86_64-450.80.02-grid.run
```
If you're prompted to install 32-bit binaries, choose Yes.
If you're prompted to modify the x.org file, choose No.

test with:

`nvidia-smi`


#### 6. set up X2GO server (ubuntu)
##### Install x2go on server (https://wiki.archlinux.org/title/X2Go#Server_side): 

`sudo apt-get update`

`sudo apt-get install x2goserver x2goserver-xsession`

`sudo systemctl enable x2goserver`  

`sudo systemctl start x2goserver`  

`sudo systemctl status x2goserver`  

##### configure x11 forwarding:

Change following settings in `/etc/ssh/sshd_config`

```
X11Forwarding yes
AllowTcpForwarding yes
X11UseLocalhost yes 
X11DisplayOffset 10
```
restart ssh service
`sudo systemctl restart sshd`

enable ssh service
`sudo systemctl enable ssh`

##### set  firewall rules for X2GO:
`sudo ufw allow 22/tcp`

##### start x2go db:
`sudo x2godbadmin --createdb`

#### 6. set up X2GO client:

Download x2go client: https://wiki.x2go.org/doku.php/download:start

##### Log in using ssh public/private key pair:
generate public private key pair with something like `ssh-keygen -t rsa -C "qjoel6398"`

add public key to gce metadata: https://cloud.google.com/compute/docs/connect/add-ssh-keys#metadata
configure x2go client connection using hostname and private key path.
 * remember that keys have usernames so make sure you are using the correct username.







