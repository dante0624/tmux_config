#!/bin/bash

# Each Tmux client has its own clipboard, separate from the system clipboard.
#
# When a client receives an OSC52 copy sequence, it updates its own clipboard,
#   and then forwards that copy sequence to the parent terminal,
#   which effectively saves the copied text to the system clipboard.
#
# But, when a paste sequence comes, the tmux client only sends its own content;
#   if the system's clipboard is out of sync with this (if a user copies 
#   content from firefox), this new content will not be pasted.
#
# The command `refresh-client -l` can be used to sync the client's clipboard
#   with the system clipboard by making an OSC52 paste request to the parent.
#
# So, remap C-p to first sync the clipboards, wait a little, and then paste.
#
# Also note that we only want this clipboard sync behavior if we are in neovim,
#   otherwise we want C-p to just work normally (get previous command).

# Get the process running in the current pane
current_process=$(tmux list-panes -F "#{pane_current_command}")

# Check if the current process is nvim and refresh client if true
[ "$current_process" = "nvim" ] && tmux refresh-client -l && sleep 0.1

# Send the original C-p key sequence
tmux send-keys C-p
