# My dotfiles

Put this in `.bashrc` or whatever

```bash
for DOTFILE in `find /Users/syko/.dotfiles/<platform>`
do
  [ -f “$DOTFILE” ] && source “$DOTFILE”
done
```
