#!/bin/bash
# create_agent.sh:  create a Unix account for an AI agent, with no administrator (root) rights.
#
# Read this script before you run it.  Then run it once, from your own account:
#     sudo bash create_agent.sh
#
# Settings:  change them before you run it.
AGENT_NAME=agent                # pick a better name:  lowercase letters and digits, starting with a letter
AGENT_DIR=/agents/$AGENT_NAME   # where the agent works.  The simpler alternative:  /home/$AGENT_NAME/work
#
# What it does, and nothing else:
#   1. installs the Ubuntu packages tmux, git, curl and acl.
#   2. creates the account AGENT_NAME:  its own group, a home in /home/AGENT_NAME, password locked (it cannot log
#      in with a password), in no administrator group (it has no sudo).
#   3. adds you (the account that ran sudo) to the agent's group, so you can read the agent's files.
#   4. creates AGENT_DIR, owned by the agent, shared with its group.
# Running it again is safe:  what already exists is left as it is.

set -euo pipefail

[ "$(id -u)" = 0 ] || { echo "Run it with sudo:  sudo bash $0"; exit 1; }
OWNER=${SUDO_USER:-}
if [ -z "$OWNER" ] || [ "$OWNER" = root ]; then
    echo "Run it with sudo from your own account, not as root:  the script adds your account to the agent's group."
    exit 1
fi
if ! [[ $AGENT_NAME =~ ^[a-z][a-z0-9]{1,30}$ ]]; then
    echo "AGENT_NAME '$AGENT_NAME':  use 2 to 31 lowercase letters and digits, starting with a letter."
    exit 1
fi
if [ "$AGENT_DIR" = "/home/$AGENT_NAME" ]; then
    echo "AGENT_DIR:  use a folder inside the home, such as /home/$AGENT_NAME/work."
    echo "(Claude Code does not remember that it may trust a home directory, so it would ask at every start.)"
    exit 1
fi

echo "== 1. packages"
apt-get update -qq
apt-get install -y -qq tmux git curl acl

echo "== 2. account $AGENT_NAME"
if id "$AGENT_NAME" > /dev/null 2>&1; then
    echo "exists already:  $AGENT_NAME"
else
    useradd --create-home --user-group --shell /bin/bash --comment "AI agent" "$AGENT_NAME"
fi
passwd -l "$AGENT_NAME" > /dev/null
chmod 750 "/home/$AGENT_NAME"
if id -nG "$AGENT_NAME" | tr ' ' '\n' | grep -qxE 'sudo|admin|wheel'; then
    echo "STOP:  $AGENT_NAME is in an administrator group.  Remove it from that group before going on."
    exit 1
fi

echo "== 3. $OWNER in group $AGENT_NAME"
usermod -aG "$AGENT_NAME" "$OWNER"

echo "== 4. working folder $AGENT_DIR"
mkdir -p "$(dirname "$AGENT_DIR")"
install -d -o "$AGENT_NAME" -g "$AGENT_NAME" -m 2770 "$AGENT_DIR"

echo
echo "== checks"
id "$AGENT_NAME"
passwd -S "$AGENT_NAME"
sudo -l -U "$AGENT_NAME" | tail -1
ls -ld "$AGENT_DIR"
echo
echo "Done.  Log out and log in again, so your new membership in group $AGENT_NAME takes effect."
