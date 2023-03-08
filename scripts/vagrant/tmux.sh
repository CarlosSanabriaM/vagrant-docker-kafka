#!/bin/bash

# TODO: Replace this script with a Tmux Session Manager such as tmuxinator? (https://github.com/tmuxinator/tmuxinator)

#region Constants
TMUX_CONFIGURATION_FILE="/etc/tmux.conf"
TMUX_SESSIONS_CONFIGURATION_DIR="/etc/.tmux"
# Session
TMUX_SESSION_NAME="zookeeper-kafka"
TMUX_SESSION_CONFIGURATION_FILE="${TMUX_SESSIONS_CONFIGURATION_DIR}/${TMUX_SESSION_NAME}"
#endregion

# Create tmux configuration file
cat <<EOF > $TMUX_CONFIGURATION_FILE
source-file $TMUX_SESSION_CONFIGURATION_FILE
EOF

# Create tmux session configuration dir
mkdir -p $TMUX_SESSIONS_CONFIGURATION_DIR

#region Create tmux sessions configuration files (https://wiki.archlinux.org/title/tmux#Session_initialization)
cat <<EOF > $TMUX_SESSION_CONFIGURATION_FILE
# Create tmux session
new-session -s $TMUX_SESSION_NAME

# Split window horizontally (in 2 panes: 0 | 1) and execute command in the right pane
split-window -h "docker exec -it vagrant-kafka-1 /bin/bash"

# Select left pane
select-pane -t left

# Execute commands in the left pane
send-keys "docker exec -it vagrant-zookeeper-1 /bin/bash" Enter
send-keys "clear" Enter

EOF
#endregion
