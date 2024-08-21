# Natural Selection
A [fish shell] plugin that makes selection as natural as a text editor.

For the most part, it is a wrapper for existing input functions with its primary purpose to track/manipulate the selected region.

It also provides functions for integrating with other plugins.

## Features

- Ends selection on cursor move
- Replaces selection on input
- Begins selecting only if not already selecting
- Makes selection accessible
- Makes selection useful outside of Vi mode
- Clipboard integration

## Requirements

- Fish 3.6.0 or later

## Installation
`fisher install daleeidd/natural-selection`

Follow on to [usage](#usage), as this plugin does not provide key bindings.

## Usage

The `_natural_selection` function is all you need to know to get everything out of the plugin. It is prefixed with an underscore to prevent namespace pollution, as you will never call this from the command line.

The following will depend on your terminal, as most of these key bindings are not the default. Add the following to your fish key bindings:

```fish
# Use fish_key_reader to find out bindings. These are a combination of escape sequences and hex codes.
# The following should already be sent by your terminal:
set --local escape              \e
set --local control_r           \cR
set --local up                  \e'[A'
set --local down                \e'[B'
set --local left                \e'[D'
set --local right               \e'[C'
set --local shift_left          \e'[1;2D'
set --local shift_right         \e'[1;2C'
set --local backspace           \x7f
set --local delete              \e'[3~'
set --local option_left         \eb
set --local option_right        \ef
# The following will need to be added to be sent by your terminal:
set --local option_shift_left   \e'[1;10D'
set --local option_shift_right  \e'[1;10C'
set --local command_shift_left  \e'[H'
set --local command_shift_right \e'[F'
set --local command_left        \ca
set --local command_right       \ce
set --local command_backspace   \cU
set --local command_delete      \ck
set --local option_backspace    \cw
set --local option_delete       \ed
set --local command_c           \e'[Q'
set --local command_x           \e'[O'
set --local command_v           \e'[L'
set --local command_a           \e'[97;9u'
set --local command_z           \e'[122;9u'
set --local command_shift_z     \e'[122;10u'

if functions --query _natural_selection
  bind $escape              '_natural_selection end-selection'
  bind $control_r           '_natural_selection history-pager'
  bind $up                  '_natural_selection up-or-search'
  bind $down                '_natural_selection down-or-search'
  bind $left                '_natural_selection backward-char'
  bind $right               '_natural_selection forward-char'
  bind $shift_left          '_natural_selection backward-char --is-selecting'
  bind $shift_right         '_natural_selection forward-char --is-selecting'
  bind $command_left        '_natural_selection beginning-of-line'
  bind $command_right       '_natural_selection end-of-line'
  bind $command_shift_left  '_natural_selection beginning-of-line --is-selecting'
  bind $command_shift_right '_natural_selection end-of-line --is-selecting'
  bind $option_left         '_natural_selection backward-word'
  bind $option_right        '_natural_selection forward-word'
  bind $option_shift_left   '_natural_selection backward-word --is-selecting'
  bind $option_shift_right  '_natural_selection forward-word --is-selecting'
  bind $delete              '_natural_selection delete-char'
  bind $backspace           '_natural_selection backward-delete-char'
  bind $command_delete      '_natural_selection kill-line'
  bind $command_backspace   '_natural_selection backward-kill-line'
  bind $option_backspace    '_natural_selection backward-kill-word'
  bind $option_delete       '_natural_selection kill-word'
  bind $command_c           '_natural_selection copy-to-clipboard'
  bind $command_x           '_natural_selection cut-to-clipboard'
  bind $command_v           '_natural_selection paste-from-clipboard'
  bind $command_a           '_natural_selection select-all'
  bind $command_z           '_natural_selection undo'
  bind $command_shift_z     '_natural_selection redo'
  bind ''                   kill-selection end-selection self-insert
end
```

### Developer Functions

#### `_natural_selection_begin_selection`
Begins the selection if not already selecting.

#### `_natural_selection_end_selection`
Ends the selection. Does not repaint command line.

#### `_natural_selection_get_selection`
Echoes the selection. Example usage:<br>
`set --local selection (_natural_selection_get_selection)`

#### `_natural_selection_is_selecting`
Is there an active selection? Uses `status`.

#### `_natural_selection_kill_selection`
Clears the selection and its contents. Repaints the command line.

#### `_natural_selection_replace_selection`
Replaces the entire selection with `<contents>`.

`<contents>`<br>
Standard usage.

`--inset-selection-by <integer> <contents>`<br>
After replacing the contents, the resulting selected region will also be reduced by `<integer>` on either side.

#### `_natural_selection_wrap_selection`
Wraps the selection with two positional arguments `<left>` and `<right>` respectively. Both arguments must be the same length for this to work correctly.

`<left> <right>`<br>
Standard usage.

## Frequently Asked Questions

### What are the supported operating systems?
It was developed on macOS, and it has not been tested elsewhere. But it should work for others.

### Can this work with X?
If there is a binding conflict, then no. It will need an integration (not taking requests). Typically, paired symbols plugins need integrations.

### Why can I not use <kbd>⌘ Command</kbd> + <kbd>V</kbd> for paste?
You can. But you will lose paste functionality elsewhere like editors. This needs to be worked out still.

### Why are you not providing bindings on install?
The amount of bindings needed is often greater than what is available from the terminal, necessitating custom key mappings. Furthermore, there is a potential for conflicts. It is much easier to just have everyone configure this themselves.

### Can this be ported to another shell?
I know this can be done with zsh, since this started out as a port of my own implementation in zsh. In fact, most of this can be done with native zsh features.

### Is there a performance impact?
I cannot quantify the performance impact at this stage. I do not notice it, but I might not be as sensitive as others.

### Will this work in Vi mode?
Vi mode has its own thing.

[fish shell]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
