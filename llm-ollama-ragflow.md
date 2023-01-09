# LLM + Ollama + Ragflow 

### Notes

- If you are using Windows + WSL, install [Nvidia Studio Drivers (860MB)](https://developer.nvidia.com/cuda/wsl).
- Also, install [CUDA Toolkit (2.3GB)](https://developer.nvidia.com/cuda-downloads).
- All details presented here works for Windows 11 + WSL2 running Debian12 + NVIDIA GeForce RTX3060 Laptop GPU + 11th Core i7 11800 + 32GB RAM.

### Install

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### Run

```bash
ollama run llama3
```

### SystemD Support

If the Ollama installation does not create a SystemD service use this example:

```
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/local/bin/ollama serve
User=cicerow
Group=cicerow
Restart=always
RestartSec=3
Environment=PATH=/home/cicerow/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin
Environment=OLLAMA_HOST=0.0.0.0:11434

[Install]
WantedBy=default.target
```
- The file path is `/etc/systemd/system/ollama.service`.
- Check the user. I am configuring the same User/Group I ran the Ollama command.
- Replicate the same PATH content of your current environment.
- Network access worked for me.
- Include the following line to expose service on the network: `Environment=OLLAMA_HOST=0.0.0.0:11434`

```bash
sudo systemctl daemon-reload
sudo systemctl enable ollama
sudo systemctl start ollama
sudo systemctl status ollama
sudo ss -ntlp
systemctl show -p Environment ollama --no-pager
```

### Other Models

| Model              | Parameters | Size  | Download                         |
| ------------------ | ---------- | ----- | -------------------------------- |
| Gemma 3            | 1B         | 815MB | `ollama run gemma3:1b`           |
| Gemma 3            | 4B         | 3.3GB | `ollama run gemma3`              |
| Gemma 3            | 12B        | 8.1GB | `ollama run gemma3:12b`          |
| Gemma 3            | 27B        | 17GB  | `ollama run gemma3:27b`          |
| QwQ                | 32B        | 20GB  | `ollama run qwq`                 |
| DeepSeek-R1        | 7B         | 4.7GB | `ollama run deepseek-r1`         |
| DeepSeek-R1        | 671B       | 404GB | `ollama run deepseek-r1:671b`    |
| Llama 4            | 109B       | 67GB  | `ollama run llama4:scout`        |
| Llama 4            | 400B       | 245GB | `ollama run llama4:maverick`     |
| Llama 3            | 7B         | 4.7GB | `ollama run llama3`              | 
| Llama 3.3          | 70B        | 43GB  | `ollama run llama3.3`            |
| Llama 3.2          | 3B         | 2.0GB | `ollama run llama3.2`            |
| Llama 3.2          | 1B         | 1.3GB | `ollama run llama3.2:1b`         |
| Llama 3.2 Vision   | 11B        | 7.9GB | `ollama run llama3.2-vision`     |
| Llama 3.2 Vision   | 90B        | 55GB  | `ollama run llama3.2-vision:90b` |
| Llama 3.1          | 8B         | 4.7GB | `ollama run llama3.1`            |
| Llama 3.1          | 405B       | 231GB | `ollama run llama3.1:405b`       |
| Phi 4              | 14B        | 9.1GB | `ollama run phi4`                |
| Phi 4 Mini         | 3.8B       | 2.5GB | `ollama run phi4-mini`           |
| Mistral            | 7B         | 4.1GB | `ollama run mistral`             |
| Moondream 2        | 1.4B       | 829MB | `ollama run moondream`           |
| Neural Chat        | 7B         | 4.1GB | `ollama run neural-chat`         |
| Starling           | 7B         | 4.1GB | `ollama run starling-lm`         |
| Code Llama         | 7B         | 3.8GB | `ollama run codellama`           |
| Llama 2 Uncensored | 7B         | 3.8GB | `ollama run llama2-uncensored`   |
| LLaVA              | 7B         | 4.5GB | `ollama run llava`               |
| Granite-3.3        | 8B         | 4.9GB | `ollama run granite3.3`          |
| Qwen 3.5 (4B)      | 4B         | 3.4GB | `ollama run qwen3.5:4b`          |

Complete list at: [https://ollama.com/library](https://ollama.com/library)

### Models downloaded

```bash
ls -lh /usr/share/ollama/.ollama/models/blobs
ls "$HOME"/.ollama/models/blobs
ls /root/.ollama/models/blobs
```

### Control service

```bash
sudo systemctl status ollama
sudo systemctl stop ollama
sudo systemctl restart ollama
```

### Run inside container and pull a model

Check other options in [https://hub.docker.com/r/ollama/ollama](https://hub.docker.com/r/ollama/ollama)

``` bash
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

```bash
curl -X POST http://localhost:11434/api/pull -d '{"model":"llama3"}'
```

### Ollama Commands

#### List available models

```bash
ollama ls
```

or

```bash
curl http://localhost:11434/api/tags
```

#### List active models (in memory)

```bash
ollama ps
```

#### Deactivate models (frees memory)

```bash
ollama stop llama3:latest
```

#### Ask via curl

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "Me explique a teoria da relatividade em poucas palavras."
}'
```

#### Format output

```bash
curl -s http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "Explique Docker em 1 frase."
}' | jq -r '.response' | tr -d '\n'
```

#### System directive

```bash
curl -s http://localhost:11434/api/chat -d '{
  "model": "llama3:latest",
  "messages": [
    { "role": "system", "content": "Você é um assistente muito conciso." },
    { "role": "user", "content": "Qual a capital da França?" }
  ],
  "stream": false,
  "keep_alive": 0
}' | jq -r 'select(.message.role=="assistant") | .message.content'
```

```bash
curl -s http://localhost:11434/api/chat -d '{
  "model": "llama3",
  "messages": [
    { "role": "system", "content": "Você é um assistente muito prolixo." },
    { "role": "user", "content": "Qual a capital da França?" }
  ]
}' | jq -r 'select(.message.role=="assistant") | .message.content'
```

#### Examples without/with tools:

```bash
curl -s http://localhost:11434/api/chat -d '{
  "model": "qwen3.5:4b",
  "messages": [
    { "role": "system", "content": "You are a very concise assistant. Short, to-the-point answers." },
    { "role": "user",   "content": "Linux command to find all files in /home/cicerow that were changed in the last 2 hours." }
  ],
  "stream": false,
  "tools": [],
  "keep_alive": 0
}'
```
total_duration: 611271242307 (611B)

```bash
curl -s http://localhost:11434/api/chat -d '{
  "model": "qwen3.5:4b",
  "messages": [
    { "role": "user",   "content": "Linux command to find all files in /home/cicerow that were changed in the last 2 hours." }
  ],
  "tools": [
    {
        "type": "function",
        "name": "shell_executor",
        "parameters": {
            "type": "object",
            "properties": {
                "command": {"type": "string"}
            },
            "required": ["command"]
        }
    }
  ],
  "keep_alive": 0
}'
```
total_duration: 85855753330 (85B)

### Conectl VSCode to Ollama using Continue

- Install continue extension on VSCode.
- Access continue plugin, access chat pannel, click on `or continue your onw models`.
  - Change it to `local`.
  - Select `skip and configure manually`.
  - Run the commands listed:
    - ollama pull llama3.1:8b
    - ollama pull qwen2.5-coder:1.5b-base
    - ollama pull nomic-embed-text:latest
  - `Connect`

- `Ctrl+l`: starts a new chat.
- `Ctrl+Alt+Space`: force autocomplete trigger (**did not work**).

### Ollama Web Client

Open WebUI is currently the most popular open-source project for hosting a GUI interface to LLMs, including Ollama models. It replaces the need to use the API directly via command line.

* **Best For:** Users who want a "ChatGPT-like" experience with features like chat history, settings management, and dark mode.
* It is highly customizable, supports many backend models (Ollama, LM Studio, etc.), and runs easily in Docker.
* **How to use:** 
```bash
docker run -d -p 3000:8080 \
           -e OLLAMA_BASE_URL=http://asus-tuf.tail8dfeeb.ts.net:11434 \
           -v open-webui:/app/backend/data \
           --name open-webui \
           --restart always \
           ghcr.io/open-webui/open-webui:main
docker run -d -p 3000:8080 \
           -e OLLAMA_BASE_URL=http://172.22.185.230:11434 \
           -v open-webui:/app/backend/data \
           --name open-webui \
           --restart always \
           ghcr.io/open-webui/open-webui:main
```
* In my case, I am running Ollama in other computer.
* Access it at `http://localhost:3000`.
* **Code:** [https://github.com/open-webui/open-webui](https://github.com/open-webui/open-webui)

# RagFlow installation

### Pre-requisites
- Kubernetes: K3S v1.33.3+k3s1
- Helm: v3.18.4

### Installation without user control

```bash
git clone https://github.com/infiniflow/ragflow.git
```

Install in default namespace:
```bash
cd ragflow/helm
helm list -A
helm install ragflow ./.
helm list -A
kubectl -n default get po,svc,secret,cm,pvc
```

Or in a specific namespace:
```bash
kubectl create ns ragflow
cd ragflow/helm
helm list -A
helm install ragflow ./. -n ragflow
helm list -A
kubectl -n ragflow get po,svc,secret,cm,pvc
```

```bash
kubectl -n default port-forward svc/ragflow 8088:80 --address 0.0.0.0
kubectl -n ragflow port-forward svc/ragflow 8088:80 --address 0.0.0.0
curl -I -XGET http://localhost:8088
# Access from your browser and register with any e-mail
```

> Note: 25GB of memory used after run Ollama and RagFlow.

### Installation with Keycloak and OAuth2 Proxy

> To be done

- [https://ragflow.io/docs/dev/configurations#oauth](https://ragflow.io/docs/dev/configurations#oauth)

### Usage from web console

RagFlow recommends to use models `llama3.2` for chat and `bge-m3` for embeddings. To download it run:

```bash
ollama pull llama3.2:latest
ollama pull bge-m3:latest
ollama ls
```

Redirect HTTP TCP/80 port to 8088 using kubectl:

```bash
kubectl -n default port-forward svc/ragflow 8088:80 --address 0.0.0.0
kubectl -n ragflow port-forward svc/ragflow 8088:80 --address 0.0.0.0
```

If you are using WSL you can access the web interface from the WSL IP. Use `ip add` command to verify de correct IP address.

#### Configure model

Model for chat:

- Click on **your profile** (upside right)
- Select **Model providers** on the left menu
- Search **Ollama** and click on **Add Model**
- **Model type**: **chat**
- **Model name**: **llama3.2:latest**
- **Base url**: http://172.21.142.158:11434/v1
- **API-Key**: [empty]
- **Max Tokens**: 150000 (TODO: try to understand and be more acurrated)

> Note: In another installation the URL `http://172.21.142.158:11434/v1` did not work. Used `http://172.21.142.158:11434/` instead.

http://172.22.185.230:11434/v1

Model for embedding:

- On the same added option (Ollhama) click on **Add Model**
- **Model type**: **embedding**
- **Model name**: **bge-m3:latest**
- **Base url**: http://172.21.142.158:11434/v1
- **API-Key**: [empty]
- **Max Tokens**: 150000 (TODO: try to understand and be more acurrated)

Set default models:

- On the same page click on **Set default models**
- Choose **llama3.2** for **chat**
- Choose **bge-m3** for **embedding**
- **OK**

> Note: I am using WSL. This IP is my WSL IP. Use `ip add` to check the correct IP.

Start a new chat for validation.

- Click on **Chat** and **Create chat**
- **Name**: **Test1**
- Click on **Test1**
- Select the correct **Model** and **Creativity** on the right side
- Click on **+** to start a new chat
- Send a question using the bottom field

### Usage from API

Make sure the k8s service is available. All following examples use TCP/8088 port.

#### Create an API Key for access

- Click on **your profile** (upside right)
- Select **API** on the left menu
- Click on **API KEY** button on the top
- Save the API key value shown by the UI.
- **OK**

For all examples, use these variables. Adapt to your scenario. These variables will be omitted in the examples below.

```bash
ADDRESS=172.21.142.158:8088
RAGFLOW_API_KEY=<YOUR_RAGFLOW_API_KEY>
```

#### Dataset - List

```bash
curl -sS --request GET \
     --url http://${ADDRESS}/api/v1/datasets \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}"
```

```bash
curl -sS --request GET \
     --url http://${ADDRESS}/api/v1/datasets \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}"|jq '.data[].name'
```

```bash
curl -sS --request GET \
     --url http://${ADDRESS}/api/v1/datasets \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}"|jq '.data[] | "\(.name) \(.id)"'
```

#### Dataset - Create

```bash
curl -sS --request POST \
     --url http://${ADDRESS}/api/v1/datasets \
     --header 'Content-Type: application/json' \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --data '{"name": "TestApi1"}'
```

```bash
AI_AGENT_AVATAR=$(base64 -w0 ai-agent.png)
curl -sS --request POST \
     --url http://${ADDRESS}/api/v1/datasets \
     --header 'Content-Type: application/json' \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --data '{"name": "TestApi2", "description": "Test2 from API", "avatar": "data:image/png;base64,'${AI_AGENT_AVATAR}'", "chunk_method": "naive", "permission": "me"}'|jq 
```

#### Dataset - Update

```bash
RAGFLOW_DATASET_ID=563bb93a875611f0b816a65601ac2791
curl -sS --request PUT \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID} \
     --header 'Content-Type: application/json' \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --data '{"name": "TeestApi2_updated"}'
```

#### Dataset - Delete

List IDs first.

```bash
curl -sS --request DELETE \
     --url http://${ADDRESS}/api/v1/datasets \
     --header 'Content-Type: application/json' \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --data '{"ids": ["563bb93a875611f0b816a65601ac2791"]}'
```

#### File - Upload

```bash
RAGFLOW_DATASET_ID=3e27afd4875611f08cd8a65601ac2791
curl -sS --request POST \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID}/documents \
     --header 'Content-Type: multipart/form-data' \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --form 'file=@./processador_snaptico.md'
```

#### File - List Documents

```bash
RAGFLOW_DATASET_ID=3e27afd4875611f08cd8a65601ac2791
curl -sS --request GET \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID}/documents \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}"
```

```bash
RAGFLOW_DATASET_ID=3e27afd4875611f08cd8a65601ac2791
curl -sS --request GET \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID}/documents \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}"|jq -r '.data.docs[] | "\(.name) \(.id) \(.run)"'
```

#### File - Parse Document

List documents first.

```bash
RAGFLOW_DATASET_ID=3e27afd4875611f08cd8a65601ac2791
RAGFLOW_DOCUMENT_ID=c4609fa2875611f085fea65601ac2791
curl -sS --request POST \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID}/chunks \
     --header 'Content-Type: application/json' \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --data '{"document_ids": ["'${RAGFLOW_DOCUMENT_ID}'"] }'
```

#### File - Change Document

```bash
RAGFLOW_DATASET_ID=3e27afd4875611f08cd8a65601ac2791
RAGFLOW_DOCUMENT_ID=c4609fa2875611f085fea65601ac2791
curl -sS --request PUT \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID}/documents/${RAGFLOW_DOCUMENT_ID} \
     --header 'Content-Type: application/json' \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --data '{"name": "main_processor.md"}'
```

#### File - Download

```bash
RAGFLOW_DATASET_ID=3e27afd4875611f08cd8a65601ac2791
RAGFLOW_DOCUMENT_ID=c4609fa2875611f085fea65601ac2791
curl -sS --request GET \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID}/documents/${RAGFLOW_DOCUMENT_ID} \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --output ./main_processor.md
```

#### File - Delete

```bash
RAGFLOW_DATASET_ID=3e27afd4875611f08cd8a65601ac2791
RAGFLOW_DOCUMENT_ID=c4609fa2875611f085fea65601ac2791
curl -sS --request DELETE \
     --url http://${ADDRESS}/api/v1/datasets/${RAGFLOW_DATASET_ID}/documents/${RAGFLOW_DOCUMENT_ID} \
     --header "Authorization: Bearer ${RAGFLOW_API_KEY}" \
     --data '{"ids": ["'${RAGFLOW_DOCUMENT_ID}'"]}'
```

### Stop Ragflow

```bash
NAMESPACE=ragflow
REPLICAS=0
kubectl -n $NAMESPACE scale --replicas=$REPLICAS statefulset.apps/ragflow-infinity statefulset.apps/ragflow-minio statefulset.apps/ragflow-mysql statefulset.apps/ragflow-redis deployment.apps/ragflow
```

> Note: Change replicas to 1 to start RagFlow again.

# Future work
- Usage from API
- RagFlow installation with KeyCloak for authentication
- RagFlow Web client using Python and Flask


