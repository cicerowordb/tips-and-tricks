## Install single master Kubernetes via kubeadm
The objective of this procedure is to install Kubernetes 1.24 using kubeadm with different nodes.

- Tested in Jan/23 with this requirements
  - Updated to install K8S 1.29 instead 1.24.
  - Two Debian 12.4.0 with kernel 6.1.0-21-amd64
    - RAM: 3000MB / Worker Free: 2300 / Master Free: 1800
    - Disk: 10GB no swap / Worker Free: 6.8GB / Master Free: 6.8GB
    - Network: bridged and intnet (intnet used for the cluster) 
    - 2 vCPU
  - Running in VirtualBox 7.0.4 in a SSD
- (*) means all nodes / (M) means Master nodes / (W) means Woker nodes
- Inspired by not the same: [https://dev.to/admantium/kubernetes-with-kubeadm-cluster-installation-from-scratch-51ae](https://dev.to/admantium/kubernetes-with-kubeadm-cluster-installation-from-scratch-51ae)

### 1-Check hostname (*)
All nodes must to have different hostnames.
```bash
cat /etc/hostname
```

### 2-Check hosts (*)
All nodes must to exist in hosts file of all nodes.
```bash
cp /etc/hosts /etc/hosts.orig
sed "s/^[0-9.]*[ ]*$HOSTNAME/#&/" /etc/hosts.orig > /etc/hosts
NEW_HOSTS=$(echo "192.168.1.251   srv01
192.168.1.252   srv02
" | cat - /etc/hosts)
echo "$NEW_HOSTS" > /etc/hosts
```

### 3-Check network (*)
Check if all interfaces are configured and if the configuration is equivalent to hosts file.
```bash
ip add|grep -o -e '(^[0-9]*: [0-9a-z]*| inet [0-9.]*)'
```

### 4-Check machine ID (*)
All nodes must to have different machine ID.
```bash
cat /sys/class/dmi/id/product_uuid
```

### 5-Kernel modules (*)
Load (now and during boot) the necessary kernel modules.
```bash
echo "overlay
br_netfilter
" > /etc/modules-load.d/k8s.conf
for module in $(cat /etc/modules-load.d/k8s.conf);do modprobe $module;done
```

### 6-Sysctl options (*)
Set (now and during boot) the necessary sysctl options.
```bash
echo "net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
" > /etc/sysctl.d/k8s.conf
sysctl --system
```

### 7-Install tools (*)
Install tools used during installation.
```bash
apt update
apt install -y apt-transport-https ca-certificates gpg curl
```

### 8-Install Apparmor (*)
Install Apparmor to improve security.
```bash
apt install -y apparmor apparmor-utils
```

### 9-Install Portmap (*)
Install Portmap to be map container ports in services and for external access.
```bash
apt install -y portmap
```

### 10-Install ContainerD (*)
Install ContainerD as the cluster container runtime.
```bash
apt install -y containerd
```

### 11-Change ContainerD config (*)
Change ContainerD config to:
- use /opt/cni/bin to CNI plugins.
- activate SystemdCgroup option.
- activate runc.v2.
```bash
cp /etc/containerd/config.toml /etc/containerd/config.toml.orig 
echo 'version = 2

[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
   [plugins."io.containerd.grpc.v1.cri".containerd]
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
    [plugins."io.containerd.grpc.v1.cri".cni]
      bin_dir = "/opt/cni/bin"
      conf_dir = "/etc/cni/net.d"
  [plugins."io.containerd.internal.v1.opt"]
    path = "/var/lib/containerd/opt"
' > /etc/containerd/config.toml
systemctl restart containerd
```

### 12-Install Kubernetes binaries (*)
Install kubeadm, kubelet and kubectl in all nodes.
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubeadm=1.29.4-2.1 kubectl=1.29.4-2.1 kubelet=1.29.4-2.1
apt-mark hold kubelet kubeadm kubectl
```

### 13-Pull images (M)
Pull images is optional, but prevent to delay execution of kubeadm init command.
```bash
kubeadm config images pull
```

### 14-Initialize cluster (M)
Check your master node IP. All nodes must to resolve host name to this IP.
```bash
kubeadm init --cri-socket /run/containerd/containerd.sock \
  --apiserver-advertise-address 192.168.1.251
```
Take note of kubeadm join command.

### 15-Configure Kubectl (M)
Configure kubectl to execute other steps.
```bash
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
ln -s /usr/bin/kubectl /usr/bin/k
```

### 16-Install pod network plugin WeaveNet
Install pod network plugin to ensure communication between pods.
```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

### 17-Check status
Check status from all Kubernetes pods.
```bash
watch k get nodes,po -A
```

### 18-Join Workers
Join all other nodes as workers in your cluster. Use command from step 14.

## NFS Manual
- NFS Server: server to share files
- Cluster nodes: Kubernetes cluster's nodes
- Allow TCP ports 111 and 3333 at firewall

### NFS Server Install
```bash
sudo apt update
sudo apt install -y nfs-kernel-server nfs-common portmap
NFS_PORT_CONFIG=$(sed 's/RPCMOUNTDOPTS="--manage-gids"/RPCMOUNTDOPTS="--port 3333"/' /etc/default/nfs-kernel-server)
echo "$NFS_PORT_CONFIG" | sudo tee /etc/default/nfs-kernel-server
sudo mkdir -p /srv/nfs/datadir
echo "/srv/nfs/datadir *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
# echo "/srv/nfs/datadir 10.0.0.1(rw,sync,no_subtree_check,no_root_squash)" | sudo tee /etc/exports
sudo exportfs -rv
sudo service rpcbind start
sudo service nfs-kernel-server start
showmount -e
```

### Cluster Nodes Install
```bash
sudo apt update
sudo apt install -y nfs-common
sudo mkdir /mnt/datadir
sudo mount -t nfs 172.29.175.145:/srv/nfs/datadir /mnt/datadir
echo "ID=cicerow;Date="$(date +"%Y-%m-%d")|sudo tee /mnt/datadir/cicerow.txt
ls -la /mnt/datadir
```

### NFS Kubernetes usage
Once running, create and apply Kubernetes manifests.

#### PV
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs
  labels:
    name: nfs
    app: nfs
spec:
  storageClassName: manual
  capacity:
    storage: 200Mi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 172.29.175.145 # NFS Server IP
    path: "/srv/nfs/datadir"
```
### PVC
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 50Mi
```

### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nfs
  name: nfs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nfs
  template:
    metadata:
      labels:
        app: nfs
    spec:
      volumes:
      - name: nfs
        persistentVolumeClaim:
          claimName: nfs
      containers:
      - image: debian
        name: debian
        args:
        - bash
        - '-c'
        - sleep 1d
        volumeMounts:
        - name: nfs
          mountPath: /mnt/datadir
```
Enter the container and check the content of `/mnt/datadir'. Check the results at NFS server.
