# Dotfiles

- Change the name of `ghostty_config` to `config` before putting it in directory

- Remember to put the filepaths of the config files here lataer

## Commands

This is the command to update the symlinks to a folder that just follows and resolves those symlinks to real files.

I do not know why its this complex but it works. 

```bash
find dotfiles_symlinked/* -depth -print0 | while IFS= read -r -d $'\0' item; do
  relative_path="${item#dotfiles_symlinked/}"
  target_path="dotfiles/$relative_path"

  if [[ -L "$item" ]]; then
    target=$(readlink -f "$item")
    cp -r "$target" "$target_path"
    echo "Copied symlink: $item -> $target_path"
  elif [[ -d "$item" ]]; then
    mkdir -p "$target_path" # Crucial: Create the directory FIRST
    find "$item" -mindepth 1 -print0 | while IFS= read -r -d $'\0' sub_item; do #copy directory contents
        sub_relative_path="${sub_item#$item/}"
        sub_target_path="$target_path/$sub_relative_path"
        if [[ -L "$sub_item" ]]; then
            sub_target=$(readlink -f "$sub_item")
            cp -r "$sub_target" "$sub_target_path"
            echo "Copied symlink in directory: $sub_item -> $sub_target_path"
        else
            cp -r "$sub_item" "$sub_target_path"
            echo "Copied file/dir in directory: $sub_item -> $sub_target_path"
        fi
    done
    echo "Copied directory: $item -> $target_path"
  else
    cp "$item" "$target_path"
    echo "Copied file: $item -> $target_path"
  fi
done
```
