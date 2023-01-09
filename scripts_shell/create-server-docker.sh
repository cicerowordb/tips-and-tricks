#!/bin/bash
# Create many Docker container server to use in Ansible with SSH keys
export server_user='cicerow'
export server_quantity='4'
# SSH - Create Keys
ssh-keygen -P "" -t rsa  -b 4096 -C "root@server.local"    -f ansible_root_rsa_key
ssh-keygen -P "" -t rsa  -b 4096 -C "cicerow@server.local" -f ansible_"$server_user"_rsa_key
# Create Dockerfile
echo 'FROM  debian:11.7
ENV   DEBIAN_FRONTEND=noninteractive
RUN   apt-get update && \
      apt-get install -y openssh-server && \
      apt-get clean
RUN   adduser --home /home/'$server_user' --uid 1201 '$server_user'
RUN   mkdir -p /run/sshd && \
      mkdir -p /root/.ssh 
COPY  ansible_root_rsa_key.pub /root/.ssh/authorized_keys
COPY  ansible_'$server_user'_rsa_key.pub /home/'$server_user'/.ssh/authorized_keys
CMD   /usr/sbin/sshd -D -4 -p 22 -f /etc/ssh/sshd_config
' > Dockerfile
# Build and Run
docker build -t ansible-server .
for x in $(seq 1 $server_quantity)
do
  echo "Container ansible-srv-$x hash:"
  docker run -d --name ansible-srv-$x --hostname ansible-srv-$x ansible-server
  SRV_IP=$(docker inspect ansible-srv-$x|grep '"IPAddress"'|head -n1|tr -d '" ,'|cut -d":" -f2)
  echo "Access Server $x"
  echo ssh -o "StrictHostKeyChecking no" -i ansible_root_rsa_key root@"$SRV_IP"
  echo ssh -o "StrictHostKeyChecking no" -i ansible_cicerow_rsa_key cicerow@"$SRV_IP"
  echo "----------------------------------------------------------------------------"
done
