# Installation

Run the below to include dotfiles in .bashrc

```shell
cat <<EOL >> ~/.bashrc
# Add personal bash customisations, aliases and favourites
if [[ -f "${HOME}/.bash_customisations" ]]; then source "${HOME}/.bash_customisations"; fi
EOL
```
