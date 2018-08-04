# My dotfiles

Put this in `.bashrc` or whatever

```bash
for DOTFILE in `find /Users/lars/Projects/.dotfiles`
do
  [ -f “$DOTFILE” ] && source “$DOTFILE”
done
```
