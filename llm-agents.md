## Claude Code with Ollama

```bash
curl -fsSL https://claude.ai/install.sh | bash
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_BASE_URL=http://localhost:11434
claude --model ministral-3:3b

claude --model ministral-3:3b --tools "Bash,Edit,Read"
claude --model ministral-3:3b --debug --verbose
```

## Gemini-CLI

- Install: `npm install -g @google/gemini-cli`

- Authentication:
    1. Start Gemini-CLI with `NO_BROWSER=true gemini`
    2. Copy the URL, paste in your authenticated browser, copy the code
    3. Paste the code into your terminal

- Check Usage: 
    1. Usage: [https://aistudio.google.com/usage](https://aistudio.google.com/usage)
    2. Rate limit: [https://aistudio.google.com/rate-limit](https://aistudio.google.com/rate-limit)

- Basic usage:
    1. Interactive mode: `gemini`
    2. Headless mode: `gemini -p 'Insert your prompt'`

- Sessions:
    1. List sessions: `NO_BROWSER=true gemini --list-sessions`
    2. Resume sessions: `NO_BROWSER=true gemini --resume SESSION_CODE`

- Check configuration
    1. Skills: `NO_BROWSER=true gemini skills list`
    2. Extensions: `NO_BROWSER=true gemini skills list`
    3. MCP: `NO_BROWSER=true gemini mcp list`

- Work with files: Include `@path/to/file.txt` in your prompt

### References
* Gemini CLI cheatsheet: [https://geminicli.com/docs/cli/cli-reference/](https://geminicli.com/docs/cli/cli-reference/)

## Codex-CLI

- Installation:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
npm install -g @openai/codex
```

- Usage with open source model:
```bash
codex --oss -m gpt-oss:120b
codex --oss -m qwen3.5:4b
```

- Authenticate with GPT (free tier):
```bash
codex login --device-auth
```
    - Open the URL and paste the code.
    - This must be enabled in ChatGPT settings first.

- Include `caveman` plugin:
    ```
    npx skills add JuliusBrussee/caveman
    ```
    - Select skills to install. Select with `space` and confirm with `enter`. I commonly select only `caveman`.
    - Select agents. Codex is the focus in this case.
    - Scope: Global.
    - Method: Symlink.
    - Proceed: Yes.
    - Install the `find-skills`: Yes.
    - Note: It is not available in Codex for Windows plugin list. But it appears as an installed plugin if installed on Codex-CLI on WSL (after restart Codex and/or Windows).


## Aider + Groq or Mistral

- Install Aider:

```bash
pip install aider-chat
```

- With Groq:
    - Access [https://console.groq.com/](https://console.groq.com/)
    - Menu > API keys > Create API key
    - Define name and expiration
    - Copy the API key

```bash
export GROQ_API_KEY=<YOUR_GROQ_API_KEY>
echo $GROQ_API_KEY
aider --model groq/llama-3.3-70b-versatile
```

- Check usage at [https://console.groq.com/dashboard/metrics](https://console.groq.com/dashboard/metrics). When you achieve the limit the Aider will give you a message in the terminal. The limits are low in fact.

- With Mistral:
    - Access [https://admin.mistral.ai/organization](https://admin.mistral.ai/organization)
    - Menu > API keys > Choose a plan > Experiment/Free >
        - Accept terms and Subscribe > Verify your phone number > Access AI Studio
        - API keys > Create new key Define name and expiration > Create new key
    - Copy API key

```bash
export MISTRAL_API_KEY=<YOUR_MISTRAL_API_KEY>
echo $MISTRAL_API_KEY
aider --model mistral/mistral-large-latest
```
- Check usage at [https://admin.mistral.ai/organization/usage](https://admin.mistral.ai/organization/usage).

