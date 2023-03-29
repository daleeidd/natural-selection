# Natural Selection
A [fish shell] plugin that makes selection as natural as a text editor.

For the most part, it is a wrapper for existing input functions with its primary purpose to keep track of and manipulate the selected region.

It also provides functions for integrations with other plugins.

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

Follow on to [usage](#usage) as this plugin does not provide key bindings.

## Usage

The `_natural_selection` function is all you need to know to get everything out of the plugin. It is prefixed with an underscore to prevent namespace pollution as you will never call this from the command line.

The following will depend on your terminal as most of these key bindings are not the default. Add the following to your fish key bindings:

```fish
# Tweak according to need. This is not a complete list of keys!
set --local letters 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM'
set --local numbers '1234567890'
set --local special '!@#$%^&*_+-=\\;,./<>?:|'
set --local pairs '\'"()[]{}'
set --local characters (string split '' "$letters$numbers$special$pairs")

# Use fish_key_reader to find out bindings. These are a combination of escape sequences and hex codes.
# The following should already be sent by your terminal:
set --local left                \e'[C'
set --local right               \e'[D'
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

if functions --query _natural_selection
  bind $left                '_natural_selection forward-char'
  bind $right               '_natural_selection backward-char'
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

  for character in $characters
    set --local escaped (string escape -- $character)
    bind $character "_natural_selection --is-character -- $escaped"
  end
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

### Will this work in Vi mode?
Unlikely. It was developed in default mode (Emacs) and I do not believe it is suitable for Vi mode.

### Will this work in X operating system?
Maybe. It was developed in macOS and it has not been tested elsewhere.

### Why cannot I use <kbd>⌘ Command</kbd> + <kbd>V</kbd> for paste?
You can. But you will lose paste functionality elsewhere like editors. This needs to be worked out still.

### Why are you not providing bindings on install?
Conflicts mainly. It is advantageous to both parties for consumers to set their own bindings.

### Why are you suggesting binding characters?
This is the simplest way to achieve results. A more elegant or efficient solution might be needed.

### Can this work with X?
If there is a binding conflict, then no. It will need an integration (not taking requests).

### Can this be ported to X shell?
I know this can be done with zsh since this started out as a port of my own implementation in zsh. In fact, most of this can be done with native zsh features.

### Is there a performance impact?
I cannot quantify the performance impact at this stage. I do not notice it, but I might not be as sensitive as others.

[fish shell]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
