# Installation

Run the below to include dotfiles in .bashrc

```shell
cat <<EOL >> ~/.bashrc
   # Add personal bash customisations, aliases and favourites
   script_location="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   if [[ -f "$script_location/.bash_customisations" ]]; then source "$script_location/.bash_customisations"; fi
EOL
```
