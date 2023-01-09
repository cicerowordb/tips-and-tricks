# Getting Started with N8N

[N8N](https://n8n.io/) lets you _"build with the precision of code or the speed of drag and drop"_.

## Docker installation

### Prerequisites
- Docker installation with compose support.

Create local directories:

```bash
mkdir db_storage redis_storage n8n_storage
```

Copy the example environment file and replace the placeholder secrets:

```bash
cp .env.template .env
```

Start the services (PostgreSQL, Redis, the N8N main service, and a worker):

```bash
docker compose up -d
```

Access the UI at [http://localhost:5678](http://localhost:5678).

Complete the initial admin setup and instance configuration.

## Kubernetes installation

### Prerequisites
- Kubernetes cluster.
- Decide whether `N8N_SECURE_COOKIE` should be `false` or `true` (default).
- If it is `true`, you need TLS/HTTPS or access through `localhost`.
- If it is `false`, you can use an `ExternalIP` or `LoadBalancer` without extra configuration.

Export the values from `.env`:

```bash
. .env
```

Replace the placeholder values and apply the manifests to your current cluster:

```bash
sed "s/CHANGE_DB_ROOT_USER/$POSTGRES_USER/;
     s/CHANGE_DB_ROOT_PASS/$POSTGRES_PASSWORD/;
     s/CHANGE_DB_NAME/$POSTGRES_DB/;
     s/CHANGE_DB_USER/$POSTGRES_NON_ROOT_USER/;
     s/CHANGE_DB_PASS/$POSTGRES_NON_ROOT_PASSWORD/;
     s/CHANGE_N8N_SECURE_COOKIE/$N8N_SECURE_COOKIE/;
" kuberentes-manifests.yaml | kubectl apply -f -
```

Check the deployment:

```bash
kubectl -n n8n get deploy,svc,cm,secret
```

If ingress and the load balancer are working in your cluster, check the service external IP and access it.

## References
- [https://docs.n8n.io/hosting/installation/docker/#using-with-postgresql](https://docs.n8n.io/hosting/installation/docker/#using-with-postgresql)
- [https://github.com/n8n-io/n8n-hosting/tree/main/docker-compose](https://github.com/n8n-io/n8n-hosting/tree/main/docker-compose)
- [https://github.com/n8n-io/n8n-hosting/tree/main/kubernetes](https://github.com/n8n-io/n8n-hosting/tree/main/kubernetes)
