# Slack hotkeys

This subfolder adds some hotkeys to the Slack application when focused:

* `ctrl h` - focuses the left text input (main window)
* `ctrl j` - focuses the next message below
* `ctrl k` - focuses the previous message above
* `ctrl l` - focuses the right text input (thread sidepane)
* `ctrl r` - starts a new `/remind me at` message
* `ctrl t` - opens a new thread for the last message in channel

These keys are disabled when the Slack application loses focus, so it doesn't conflict with other apps.

## Installation

If you want to copy these to your own config files:

```bash
mkdir -p ~/.hammerspoon/slack
```

Then, download each of the `.lua` files in this `slack/` directory to your own computer's `~/.hammerspoon/slack` folder.

Finally, require it in your main `init.lua`:

```lua
-- ~/.hammerspoon/init.lua

require("slack")
```
