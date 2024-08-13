#!/usr/bin/env bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y de.haeckerfelix.Shortwave
flatpak install -y org.mozilla.firefox
flatpak install -y org.mozilla.Thunderbird
flatpak install -y com.slack.Slack
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/powerlevel10k
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
distrobox create -Y --image quay.io/toolbx-images/alpine-toolbox:latest --additional-packages "gcc g++ aws-cli py3-pip neovim git tig nnn fzf nodejs fd xsel zsh eza dtach stow htop sd ripgrep" --init-hooks "sudo ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman && pip3 install --user podman-compose && apk del py3-pip && cd ~/.etc && stow home && chsh -s /bin/zsh && zsh -c \"exit\""


