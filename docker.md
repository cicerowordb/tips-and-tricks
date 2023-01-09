## Docker Swarm
Swarm is Docker's built-in clustering mode. Key points to keep in mind:
- It is simpler and usually consumes fewer resources than a full Kubernetes setup.
- Containers are reachable only from cluster nodes unless you explicitly publish a service.
- A cluster can have multiple managers, but only one leader at a time.
- Use an odd number of managers to maximize quorum availability.

### Initialize cluster
```bash
docker swarm init --advertise-addr 10.0.0.1
```

### Add a worker
```bash
docker swarm join --token <TOKEN> 10.0.0.1:2377
```

### Check installation
```bash
docker node ls
docker system info|egrep -e '(Swarm:|Is Manager|ClusterID|Nodes|Heartbeat Per)'
docker node inspect <NODE>
```

### Other useful commands
```bash
docker swarm leave --force
docker node update --availability [drain|active] <NODE>
```

### Manage services
```bash
docker service create --replicas 3 --name websrv nginx
docker service create --replicas 3 --name websrv --publish 8080:80 nginx
docker service create --name mysql --network=interna --replicas 1 -e MYSQL_ROOT_PASSWORD=<STRONG_PASSWORD> -e MYSQL_DATABASE=dados mysql
docker service create -- name cifra --network=interna --replicas 1 -p 8082:5002 cifra_sd
docker service ls
docker service ps websrv
docker service scale websrv=2
docker service rm websrv
```

### Labels and constraints
```bash
docker node ls
docker node update --label-add=name=srv02 xvnunv1zs4yzv8hyj3t09f41t
docker node update --label-add=ssd=true xvnunv1zs4yzv8hyj3t09f41t
docker node inspect xvnunv1zs4yzv8hyj3t09f41t|egrep -e '"Spec"' -A 6
docker service update --constraint-add=node.labels.ssd==true cifra 
docker service scale cifra=1
docker service update --constraint-add=node.labels.ssd==true cifra
docker service scale cifra=3
```
