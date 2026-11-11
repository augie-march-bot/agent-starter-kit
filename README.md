# agent-starter-kit

Getting started with an AI agent on your own Linux server:  an agent (Claude Code) in its own unprivileged account,
which you reach from a browser or phone, which looks after the server, and which helps with your work.  Anything
needing root, the agent drafts as a short script, and you review and run it.

Written for UC Davis faculty, but nothing in it depends on UC Davis.

## How to use it

Two prompts, nothing else.

**1. In a Claude chat** (claude.ai or the Claude app):

> Please read https://raw.githubusercontent.com/augie-march-bot/agent-starter-kit/main/server_brief.txt and get started.

The chat walks you through it, one step at a time, with a check after each:  your Claude plan, a server (with a
ready-to-send request to IT if you have none yet), logging in, sudo, a name for your agent, its account, Claude Code,
the first start, Remote Control.  It ends by handing you off to your agent.

**2. To your new agent**, in its Remote Control session:

> Please read https://raw.githubusercontent.com/augie-march-bot/agent-starter-kit/main/agent_brief.txt and get started.

The agent sets up its notes and rules, checks the server over (read-only), drafts a shared folder for the two of you,
and asks about your work.

**No server yet?**  Add "This is a dry run." to the first prompt.  The chat goes through every step and shows you the
commands without asking you to run them, so you can see what you are in for.

The briefs are written and tested for Claude.  Other chat services will likely work too, with some adapting:  if one
cannot read a web address, paste the contents of `server_brief.txt` into it instead.

## What is here

| File | For |
|---|---|
| `server_brief.txt` | the chat:  how to guide you through the setup |
| `agent_brief.txt` | your agent:  who it is, how it works, its first tasks |
| `scripts/create_agent.sh` | creates the agent's account, with no root rights (you run it with sudo, after reading it) |
| `scripts/start_agent.sh` | starts the agent in tmux, with Remote Control (run as the agent) |
| `templates/agents.txt` | the agent's rules:  GO, root work as reviewed scripts, state on disk, honesty |
| `templates/CLAUDE.md` | the agent's identity, loaded at every start |

## Safety

- Read every script before you run it, `create_agent.sh` especially:  it runs as root.  It is short and commented,
  and the chat explains it.
- The agent never has sudo.  The script checks this, and the agent checks it again in its first task.
- Never paste a password, key, token or login code into a chat.  The briefs never ask for one.

## License

MIT (see `LICENSE`).
