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
    --metadata startup-script-url="https://<personal-access-token>@raw.githubusercontent.com/qjoel6398/bollix/master/gce_setup.sh" \
    --zone us-central1-a
```
#### 2. set up X2GO client:
##### Download x2go client: https://wiki.x2go.org/doku.php/download:start

##### Log in using ssh public/private key pair:
1. generate public private key pair with something like `ssh-keygen -t rsa -C "qjoel6398"`

2. add public key to gce metadata: https://cloud.google.com/compute/docs/connect/add-ssh-keys#metadata
configure x2go client connection using hostname and private key path.
 * remember that keys have usernames so make sure you are using the correct username.

  
### Installing and setting up Unity:



### TO DO:
  - get gce startup script to work.
