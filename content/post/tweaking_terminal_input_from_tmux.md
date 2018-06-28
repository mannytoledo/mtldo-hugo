+++
title = "Tweaking Terminal Input From Tmux"
date = "2015-11-16T18:48:32-05:00"
draft = false
tag = "Getting Started"

+++

Ever since I upgraded to Mavericks my Neovim experience in tmux had been less
than ideal. It was the oddest behavior and so minor I told myself I could deal
with it. I told myself it wasn’t so bad for a long while. For reasons beyond my
understanding, I could no longer use my `^H` key to move to the left pane in
Neovim. I could `^L` to go right, `^J` for the pane below, or even `^K` for the pane
above. Not having changed anything in my nvimrc I new it had to be something in
the system that changed. The upgrade also required that I recompile Neovim,
maybe that was the culprit.  Fast forward to last month, I finally made time to
dig into this once and for all. No longer would I ^L until I circled all the
way around. Unfortunately my Google searches only brought me down the same
paths I’d travelled before. Heartbroken, I decided to watch a Youtube video on
turning “Vim and Tmux into and IDE Like Environment” to seek inspiration. Mr.
ColbyCheeze gave a pretty good walk through of his vimrc. I decided to get
a closer look when all of a sudden there it was, a link to the Neovim issue
that had slowly been torturing me.  It seems that terminfo can’t be trusted. It
turns out that `^H`registers as backspace, <BS> in terminals in OSX and
sometimes Arch Linux. You can investigate this yourself by running ~$ infocmp
$TERM|grep kbs This will print out the key descriptions filtering for the kbs
entry. You might see that it has ^H listed for kbs. This is the backspace key
description. First fix I saw on the issue was too heavy handed, totally
destroying the use of backspace.  if has(‘nvim’) nmap <BS> <C-W>h endif
Overriding the terminal setting seemed like a better option. After all, if the
terminal was wrong why not correct it.  

```
~$ infocmp $TERM | sed ‘s/kbs=^[hH]/kbs=\\177/’ > $TERM.ti
~$ tic $TERM.ti
```

This loaded up the new values in the terminal correctly but still didn't change
the behavior of Neovim whether I was using tmux or not. A better approach was
to have the terminal send appropriate CSI codes for special key combinations.
There is a way to do this in iTerm2.

1. iTerm2 -> Preferences -> Keys ( or Cmd + , )
2. Press +
3. Press Ctrl+H as Keyboard Shortcut
4. Choose Send Escape Sequence as Action
5. Type [104;5u for Esc+

This worked immediately until I got into Tmux. It would print the literal
104;5u every time. To get this to work in tmux I replaced my tmux pane left
command with this bind -n C-h if-shell “$is_vim” “send-keys Escape ‘[104;5u’”
“select-pane -L”
Here I am sending the escape sequence instead of C-h which is interpreted
correctly by Neovim and doesn’t force me to change settings for iterm2 across
the board.  I rarely use Neovim outside of tmux and haven’t felt a need for
a solution that works with and without tmux. It’s fairly easy to swap profiles
in iTerm2 to solve for those needs. I hope this helps some of you who might
have also gotten stuck on this issue.
