## WSL

Open a PowerShell window as Administrator and run these commands:
```powershell
wsl --list -o
# Choose one of the available distributions
wsl --install Ubuntu
# Enter the username and password you want to use in Linux
```
**Optional**: Enable SystemD
```bash
echo -e "[boot]\nsystemd=true\n" | sudo tee /etc/wsl.conf
```

I also recommend installing the Windows Terminal app from the Microsoft Store.

Other commands that may be useful:
```powershell
wsl --terminate Ubuntu   # Stops the distro without uninstalling it
wsl --unregister Ubuntu  # Removes the distro
wsl --update             # Updates WSL distributions
wsl --shutdown           # Shuts down all distributions and the supporting VM
```
I recommend configuring [Sudo without Password](linux.md#sudo-without-password) if this is only a test environment.

### Duplicate WSL

Backup:
```powershell
wsl --export Ubuntu Ubuntu-SystemD.tar
```

Duplicate:
```powershell
wsl --import Ubuntu-SystemD-22.04 .\Ubuntu-SystemD-22.04 .\Ubuntu-SystemD.tar
wsl -d Ubuntu-SystemD-22.04
  exit
wsl --list -v
wsl --list
```
Open your terminal application and review the available options.

### Docker on WSL

To install Docker on WSL, run these commands in a Debian-based distribution:
```bash
sudo apt update
sudo apt install -y curl
curl -sSL get.docker.com|bash
sudo adduser $USER docker
sudo service docker start
```

The script may suggest canceling the installation and will wait for 20 seconds. Just wait.

To test the installation:
```bash
sudo login  # Enter your username and password
docker info
docker image ls
docker container ls -a
```

Whenever you want to use Docker, start the service with:
```bash
sudo service docker start
```

### K3s on WSL

Open the releases page and copy the desired release URL to use in the `K3S_LINK` variable:
[https://github.com/rancher/k3s/releases/](https://github.com/rancher/k3s/releases/)

Now open your preferred WSL distribution and run:
```bash
K3S_LINK='https://github.com/k3s-io/k3s/releases/tag/v1.29.6+k3s2'
wget $(sed 's/tag/download/' <<< $K3S_LINK/k3s)
sudo chmod +x k3s
sudo mv k3s /usr/local/bin
mkdir ~/.kube || :
cp ~/.kube/config ~/.kube/config.bkp || :
sudo k3s server &
sleep 15s
sudo k3s kubectl config view --raw > ~/.kube/config
sudo k3s kubectl get nodes
sudo chmod a+r /etc/rancher/k3s/k3s.yaml # careful: testing only
```

I recommend running the second-to-last command in another terminal so the k3s logs do not get in the way. I also recommend installing [kubectl](#install-kubectl).

### Install Kubectl
```bash
KUBECTL_VERSION='1.29.6'
curl -LO "https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin
sudo ln -s /usr/local/bin/kubectl /usr/local/bin/k
kubectl version
```

### Install Helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
bash get_helm.sh
rm -f get_helm.sh
```

### Install Terraform

Check new versions: [https://releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform)

```bash
VERSIONS='1.12.2 1.3.6'
for version in $VERSIONS
do
  wget -c https://releases.hashicorp.com/terraform/"$version"/terraform_"$version"_linux_amd64.zip -O terraform_"$version".zip
  unzip terraform_"$version".zip
  sudo mv terraform /usr/local/bin/terraform_"$version"
done
FIRST_VERSION=$(cut -d' ' -f1 <<< $VERSIONS)
sudo ln -s /usr/local/bin/terraform_$FIRST_VERSION /usr/local/bin/terraform
rm -f *.zip
```

### Install Kustomize
```bash
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin/
kustomize version
```

### YQ
Install:
```bash
VERSION=v4.2.0 BINARY=yq_linux_amd64; \
    sudo wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} \
    -O /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq
```

Tips:
- Always use single quotes around the command and double quotes inside it.
- More information: [https://mikefarah.gitbook.io/yq/](https://mikefarah.gitbook.io/yq/)

Read values from YAML:
```bash
yq eval configmap.yaml
yq eval '.data' configmap.yaml
yq eval '.data.DB_HOST' configmap.yaml
yq eval '.labels' configmap.yaml
```

Insert/update values in a file:
```bash
yq eval '.data.DB_BASE = "app"' configmap.yaml
yq eval '.data.DB_BASE = "app"|.data.DB_PORT = "5433"' configmap.yaml
yq eval  '.metadata.annotations."kubernetes.io/description" = "Database connection"|
          .metadata.annotations.owner = "cicerow"' configmap.yaml
```

Delete:
```bash
yq eval 'del(.data.DB_BASE)' configmap.yaml
```

## GitHub command line
[https://hub.github.com/hub.1.html](https://hub.github.com/hub.1.html)
```bash
apt install -y hub
```

## Ansible via Pip
```bash
sudo apt install python3 python3-pip python3-venv
pip3 install ansible==7.1.0
ln -s ~/.local/lib/python3.10/site-packages/ansible* /usr/local/bin/
```

### Ansible new project
```bash
mkdir -p ~/ansible/my-servers/roles
cd ~/ansible/my-servers
echo "[defaults]
interpreter_python=/usr/bin/python3
inventory=./hosts
" > ansible.cfg
echo "
[masters]
srv01 ansible_host=192.168.1.241 ansible_ssh_private_key_file=~/.ssh/id_rsa
[workers]
srv02 ansible_host=192.168.1.242 ansible_ssh_private_key_file=~/.ssh/id_rsa
srv03 ansible_host=192.168.1.243 ansible_ssh_private_key_file=~/.ssh/id_rsa
[nodes:children]
masters
workers
" > hosts
ansible -m shell -a 'hostname' all
```

### Ansible basic playbook
```bash
echo '---
- hosts: nodes
  become: true 
  tasks:
    - name: Install Tree
      shell: apt update && apt install tree
    - name: ETC Subtree
      shell: tree /etc/|head -n10
      register: result
    - name: Show Results
      debug:
        var: result.stdout_lines
' > play01.yaml
```

### Ansible Callback
Configure it in the `ansible.cfg` file:
```bash
echo 'stdout_callback=minimal' >> ansible.cfg
```

Options are:
- minimal
- unixy
- default
- yaml
- json
- ansible-doc -t callback -l

Use it when running the playbook:
```bash
ANSIBLE_STDOUT_CALLBACK=unixy ansible-playbook ...
```

## ACT - Github Actions Locally
[https://github.com/nektos/act](https://github.com/nektos/act)

This tool simulates GitHub Actions locally. You can trigger a new push or pull request event, and ACT will download a container image and run the equivalent workflows from `.github/workflows/` inside a new container. It depends on Docker.

### Install
```bash
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
sudo mv ./bin/act /usr/local/bin/
rm -rf bin
```

### Usage

- list all actions in this repository
  ```bash
  act -l
  ```

- simulate a push event (confirm the runner size only the first time)
  ```bash
  act push
  ```

- use secrets
  ```bash
  act push -s MY_SECRET=123123123
  act pull_request -s DOCKER_USER=cicerowordb -s DOCKER_PASS=MINhaSUPerSENha123
  ```

## Install Istio

Check latest versions: [https://github.com/istio/istio/releases](https://github.com/istio/istio/releases)
Check Istio x Kubernetes compatibility: [https://istio.io/latest/docs/releases/supported-releases/#support-status-of-istio-releases](https://istio.io/latest/docs/releases/supported-releases/#support-status-of-istio-releases)

```bash
# Download
export ISTIO_VERSION=1.22.2 TARGET_ARCH=x86_64
kubectl create ns istio-system
curl -sL https://istio.io/downloadIstio| sh - > /dev/null

# Install
istio-$ISTIO_VERSION/bin/istioctl install -y --set components.ingressGateways.[0].enabled=false --set components.ingressGateways.[0].name=istio-ingressgateway

# Add-ons
kubectl -n istio-system apply -f istio-$ISTIO_VERSION/samples/addons/prometheus.yaml
kubectl -n istio-system apply -f istio-$ISTIO_VERSION/samples/addons/grafana.yaml
kubectl -n istio-system apply -f istio-$ISTIO_VERSION/samples/addons/loki.yaml
kubectl -n istio-system apply -f istio-$ISTIO_VERSION/samples/addons/kiali.yaml
kubectl -n istio-system apply -f istio-$ISTIO_VERSION/samples/addons/jaeger.yaml

# Extras
kubectl -n istio-system apply -f istio-$ISTIO_VERSION/samples/addons/extras/skywalking.yaml
kubectl -n istio-system apply -f istio-$ISTIO_VERSION/samples/addons/extras/zipkin.yaml
```

## Trivy for images scan

Installation

- Check for new versions [https://github.com/aquasecurity/trivy/releases/](https://github.com/aquasecurity/trivy/releases/)

```bash
cd /tmp
wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.tar.gz
tar xf trivy_0.18.3_Linux-64bit.tar.gz
sudo cp trivy /usr/local/bin
```

Scan images

```bash
trivy image python:3.9.21-bookworm
trivy image --severity HIGH,CRITICAL,MEDIUM --exit-status 1
```

Scan code

```bash
trivy fs --severity HIGH,CRITICAL,MEDIUM --exit-code 1 .
```

Scan k8s manifests

```bash
trivy k8s --file deployment.yaml
```

Scan a Dokerfile

```bash
trivy config Dockerfile
```
