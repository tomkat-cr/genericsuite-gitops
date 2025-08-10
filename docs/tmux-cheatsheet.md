# Tmux Cheatsheet

Tmux commands are typically initiated with a prefix key, which is Ctrl+b by default, followed by a command key.

## Window Management:

- Ctrl+b c: Create a new window.
- Ctrl+b p: Move to the previous window.
- Ctrl+b n: Move to the next window.
- Ctrl+b [number]: Move to a specific window by its index (0-indexed).
- Ctrl+b ,: Rename the current window.
- Ctrl+b &: Close the current window.
- Ctrl+b w: List all windows in the current session for easy navigation.

## Pane Management:

- Ctrl+b %: Split the current pane horizontally (into left and right panes).
- Ctrl+b ": Split the current pane vertically (into top and bottom panes).
- Ctrl+b [arrow key]: Move to an adjacent pane in the direction of the arrow key.
- Ctrl+b o: Cycle through panes in the current window.
- Ctrl+b x: Close the current pane.
- Ctrl+b z: Toggle zoom for the current pane (maximizes/restores).
- Ctrl+b ;: Move to the previously active pane.
- Ctrl+b :resize-pane -[direction] [amount]: Resize the current pane (e.g., -L 5 to move the left boundary left by 5 units). 

## Session Management:

- Ctrl+b d: Detach from the current session. The session continues to run in the background.
- Ctrl+b s: List all sessions and allow selection.
- tmux new -s [session_name]: Create a new session with a specified name.
- tmux attach -t [session_name]: Attach to a named session.
- tmux kill-session -t [session_name]: Kill a specific session.
- Ctrl+b $: Rename the current session.

## Other Useful Commands:

- Ctrl+b ?: Display a list of all key bindings.
- Ctrl+b [: Enter copy mode to scroll and copy text from the buffer. 
- Ctrl+b ]: Paste the most recently copied text.
- Ctrl+b :: Enter the tmux command prompt to type commands directly.
