#!/bin/bash
# start_agent.sh:  start this agent's Claude Code session in tmux, with Remote Control.
#
# Run it as the agent, from your own account:
#     sudo -iu AGENT_NAME bash start_agent.sh
#
# Setting:  the same working folder as in create_agent.sh.
AGENT_DIR=/agents/$(id -un)     # the alternative layout:  $HOME/work
#
# The session runs in the tmux session named after the agent, in AGENT_DIR.  In claude.ai/code and in the Claude
# app it appears as <server>-<agent>.  The agent starts idle and waits for you.
# Before the first start, run Claude Code once by hand in AGENT_DIR (login, trust the folder, /remote-control).

set -eu

A=$(id -un)
[ -d "$AGENT_DIR" ] || { echo "No folder $AGENT_DIR:  check the setting at the top of this script."; exit 1; }
CLAUDE=$(command -v claude || echo "$HOME/.local/bin/claude")
[ -x "$CLAUDE" ] || { echo "Claude Code is not installed for $A."; exit 1; }
if ! "$CLAUDE" auth status > /dev/null 2>&1; then
    echo "$A is not logged in to Claude.  First run Claude Code by hand:  cd $AGENT_DIR && $CLAUDE"
    exit 1
fi
if tmux has-session -t "$A" 2> /dev/null; then
    echo "Already running.  To see it:  tmux attach -t $A"
    exit 0
fi
tmux new-session -d -s "$A" -c "$AGENT_DIR" "$CLAUDE --remote-control $(hostname -s)-$A"
echo "Started $(hostname -s)-$A in $AGENT_DIR."
echo "To see it here:  tmux attach -t $A   (leave it running with Ctrl-b d)"
