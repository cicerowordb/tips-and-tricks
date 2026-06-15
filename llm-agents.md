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

## Opencode + Ollama model

- Install opencode
    ```
    curl -fsSL https://opencode.ai/install | bash
    # OR
    npm i -g opencode-ai
    ```
    - Create a config file:
        ```
        mkdir -p ~/.config/opencode || :
        mv ~/.config/opencode/opencode.json ~/.config/opencode/opencode.json.$(date +"%Y-%m-%d_%H-%M-%S") || :
        ```
    - Include configuration (I selected Qwen3.5:8b):
        ```
        echo '
        {
            "$schema": "https://opencode.ai/config.json",
            "provider": {
                "ollama": {
                    "npm": "@ai-sdk/openai-compatible",
                    "name": "Ollama (local)",
                    "options": {
                        "baseURL": "http://localhost:11434/v1"
                    },
                    "models": {
                        "qwen3.5:4b": {
                        "name": "qwen3.5:4b"
                        }
                    }
                }
            }
        }
        ' > ~/.config/opencode/opencode.json
        ```
    - Access the correct directory and run opencode:
        ```
        source ~/.bashrc
        opencode
            /models
            # select Ollama (local) qwen3.5:4b
        ```
- OpenCode using Codex tier for ChatGPT Pro/Plus.
    - `/connect`
    - Select `OpenAI`
    - Select `ChatGPT Pro/Plus`
    - Click on link
    - Authenticate in your browser
- It is not possible to use a Gemini-CLI tier, but I solved this using it as OpenCode Agent (see below).

Notes:
- Desktop available for macOS (Apple Silicon/Intel), Windows (x64), Linux (.deb/.rpm).
- OpenCode Extensions available for VS Code, Cursor, Zed, Windsurf, VSCodium.
- [Zen](https://opencode.ai/zen) models are free from OpenCode project.
    - It is possible to include credits.
- Agents:
    - `@general` is the default agent.
    - `@explore` is a read only agent to find information.

Shortcuts:
- Help: `ctrl+p`
- Change mode (Plan/Build): `tab`
- Change to shell mode: `!`
- The prefix shortcut is `ctrl+x`
    - Models: `m`
    - Editor: `e`
    - New session: `n`
    - Switch session: `l`
    - Compact context: `c`
    - Undo: `u`
    - Sidebar: `b`
    - Switch agent: `a`
    - Switch theme: `t`
- Change variant/effort: `ctrl+t`
- Navigate: `pg-up` and `pg-down`

Main slash commands:
- `/models`: selects a model (some free by default).
- `/variants`: change variant.
- `/init`: creates an AGENTS.md for context control.
- `/diff`: diff viewer for git changes.
- `/compact`: helps to control the context usage.
- `/agents`: switches agents (plan and build by default).
- `/undo`: rolls back the last AI prompt or code modification request.
- `/editor`: opens editor for multiline prompt.
- `/sessions`: shows a list of previous workspace projects to load or resume.

### Gemini-CLI Subagent for OpenCode

#### 1. Create a Gemini subagent in `.opencode/agents/gemini.md`

```bash
mkdir -p ~/.config/opencode/agents/ || :
echo > ~/.config/opencode/agents/gemini.md
cat <<EOF > ~/.config/opencode/agents/gemini.md
---
description: Query Gemini CLI free tier without API costs. Use @gemini when you want gemini's answer alongside your primary model.
mode: subagent
permission:
  bash:
    "gemini -p *": allow
    "*": deny
---

You are a bridge to the pre-authenticated Gemini CLI (`gemini`). 
Gemini is already logged in and ready — do NOT attempt to configure or authenticate it.

When asked a question, run:

  gemini -p 'the question here'

Return Gemini's response verbatim. Keep prompts concise.
EOF
```
#### 2. Test

We can verify the agent works by:

- Running `gemini -p 'Say hello in one word'` directly to confirm the CLI works.
- Then from inside opencode, invoking `@gemini Say hello in one word` to confirm the agent routes correctly.
- I also tested from inside opencode with this prompt and I enjoyed the result:
    - `send the content of .bashrc to @gemini agent and request a commented version. save the commented version in bashrc-commented.`

#### 3. Other details
- Where to create the agent 
    - project-local (`./.opencode/agents/gemini.md`) 
    - or global (`~/.config/opencode/agents/gemini.md`)?

### Frontend-design Skill

```bash
mkdir -p ~/.config/opencode/skills/frontend-design/
echo > ~/.config/opencode/skills/frontend-design/SKILL.md
curl -sSfL https://raw.githubusercontent.com/anthropics/skills/refs/heads/main/skills/frontend-design/SKILL.md >  ~/.config/opencode/skills/frontend-design/SKILL.md
```

Restart opencode if needed. To use it, just ask something related to the skill or use `/skill` command and choose `frontend-design` from the list.

> You can use `./.opencode/skills/frontend-design/SKILL.md` to use inside a project intead of a global installation.

References:
- [https://opencode.ai/download](https://opencode.ai/download)
- [https://opencode.ai/docs/providers/#ollama](https://opencode.ai/docs/providers/#ollama)
- [https://opencode.ai/zen](https://opencode.ai/zen)

## Agent Skills

Skills are reusable instruction sets that teach an AI agent how to handle specific tasks — coding style, design decisions, domain conventions, tool usage patterns.

### Anatomy

Each skill lives in its own directory with a `SKILL.md`:

```yaml
---
name: skill-name
description: When this skill should trigger (used for automatic matching)
---
# Skill Title

Instructions for the agent. Use imperative tone, explain the *why*
behind constraints, and be specific about output formats and workflows.
```

Optional bundled resources:
```
skill-name/
├── SKILL.md        # Required: frontmatter + instructions
├── scripts/        # Reusable scripts for deterministic tasks
├── references/     # Docs loaded into context on demand
└── assets/         # Templates, icons, fonts, etc.
```

### How they work

- **Description** (frontmatter) — always in context, used to decide if the skill applies
- **Body** (SKILL.md) — loaded when the skill is triggered
- **Bundled files** — loaded on demand; scripts can execute without loading into context

### Where to find skills

- **Public library**: [github.com/anthropics/skills](https://github.com/anthropics/skills) — frontend-design, mcp-builder, pdf, pptx, xlsx, and more
- **Community**: various repos and gists

### Using skills

**Opencode:**
- Global: `~/.config/opencode/skills/<name>/SKILL.md`
- Project-local: `./.opencode/skills/<name>/SKILL.md`
- Trigger: `/skill` command or mention the skill name naturally; the agent consults it when the task matches its description

**Gemini-CLI:**
```bash
gemini skills add <path/to/skill>
gemini skills list
```

**Claude Code:** skills go in the project's `.claude/skills/` directory or a configured global path.

### Python Skills
- [https://raw.githubusercontent.com/ludo-technologies/python-best-practices/refs/heads/main/skills/coding-standards/SKILL.md](https://raw.githubusercontent.com/ludo-technologies/python-best-practices/refs/heads/main/skills/coding-standards/SKILL.md)
- [https://github.com/ludo-technologies/python-best-practices/blob/main/skills/tooling/SKILL.md](https://github.com/ludo-technologies/python-best-practices/blob/main/skills/tooling/SKILL.md)

### Terraform Skills
- [https://github.com/hashicorp/agent-skills/tree/main/terraform](https://github.com/hashicorp/agent-skills/tree/main/terraform)
    - code-generation:
        - azure-verified-modules
        - terraform-search-import
        - terraform-style-guide
        - terraform-test
    - module-generation:
        - refactor-module
        - terraform-stacks
    - provider-development:
        - new-terraform-provider
        - provider-actions
        - provider-docs
        - provider-resources
        - provider-test-patterns
        - run-acceptance-tests

### Bash Skills
- [https://raw.githubusercontent.com/bentsolheim/public-skills/refs/heads/main/skills/bash/SKILL.md](https://raw.githubusercontent.com/bentsolheim/public-skills/refs/heads/main/skills/bash/SKILL.md)
