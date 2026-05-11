#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$DOTFILES_DIR/install.log"

log()     { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG"; }
section() { echo "" | tee -a "$LOG"; echo "════════════════════════════════════" | tee -a "$LOG"; log "  $*"; echo "════════════════════════════════════" | tee -a "$LOG"; }
ok()      { log "  ✓ $*"; }
skip()    { log "  — $*"; }

[[ $EUID -eq 0 ]] && echo "Do not run as root!" && exit 1
ping -c1 archlinux.org &>/dev/null || { echo "No internet."; exit 1; }

section "System update"
sudo pacman -Syu --noconfirm && ok "Updated"

section "Packages"
bash "$DOTFILES_DIR/packages/install-packages.sh" && ok "Done"

section "Node.js"
command -v node &>/dev/null || sudo pacman -S --needed --noconfirm nodejs npm
ok "node $(node -v) / npm $(npm -v)"

section "HyDE"
if [[ ! -d "$HOME/HyDE" ]]; then
    git clone https://github.com/HyDE-Project/HyDE.git "$HOME/HyDE"
    (cd "$HOME/HyDE" && bash install.sh) && ok "HyDE installed"
else
    skip "HyDE already installed"
fi

section "Configs"
cp -r "$DOTFILES_DIR/configs/." "$HOME/.config/" && ok "configs"
cp "$DOTFILES_DIR/shell/.zshenv" "$HOME/" && ok ".zshenv"
cp "$DOTFILES_DIR/misc/.gitconfig" "$HOME/" && ok ".gitconfig"
mkdir -p "$HOME/Pictures/Wallpapers" && ok "Wallpapers dir"

section "Services"
for svc in NetworkManager bluetooth sddm tlp ufw docker libvirtd; do
    systemctl list-unit-files | grep -q "^${svc}.service" \
        && sudo systemctl enable "$svc" && ok "$svc" \
        || skip "$svc"
done
systemctl is-enabled power-profiles-daemon &>/dev/null \
    && sudo systemctl disable power-profiles-daemon \
    && ok "power-profiles-daemon disabled"

section "UFW"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw --force enable && ok "UFW ready"

section "Zsh"
[[ "$SHELL" != "$(which zsh)" ]] && chsh -s "$(which zsh)" && ok "zsh default" || skip "already zsh"

section "Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ok "oh-my-zsh installed"
else
    skip "already installed"
fi

section "Neofetch server"
if [[ -d "$DOTFILES_DIR/neofetch-server" ]]; then
    cp -r "$DOTFILES_DIR/neofetch-server" "$HOME/"
    (cd "$HOME/neofetch-server" && npm install) && ok "ready"
fi

section "Done!"
log "Next: reboot → p10k configure → restore SSH keys → add wallpapers"