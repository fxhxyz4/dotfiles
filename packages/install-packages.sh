#!/usr/bin/env bash

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$DIR/install-packages.log"

log()     { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG"; }
section() { echo "" | tee -a "$LOG"; echo "════════════════════════════════════════" | tee -a "$LOG"; log "  $*"; echo "════════════════════════════════════════" | tee -a "$LOG"; }
ok()      { log "  ✓ $*"; }
skip()    { log "  — $*"; }

if [[ $EUID -eq 0 ]]; then
    echo "Root not permitted!"
    exit 1
fi

if ! ping -c1 archlinux.org &>/dev/null; then
    echo "Please connect to wifi."
    exit 1
fi

section "Chaotic-AUR"
if ! grep -q "chaotic-aur" /etc/pacman.conf; then
    log "Add Chaotic-AUR..."
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --noconfirm \
        'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'

    sudo pacman -U --noconfirm \
        'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" \
        | sudo tee -a /etc/pacman.conf
    
    sudo pacman -Sy
    ok "Chaotic-AUR added"
else
    skip "Chaotic-AUR ready"
fi

section "yay"
if ! command -v yay &>/dev/null; then
    log "Build yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    tmp=$(mktemp -d)

    git clone https://aur.archlinux.org/yay-git.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)

    rm -rf "$tmp"
    ok "yay ready"
else
    skip "yay ready"
fi

section "Pacman packages"
PKG_FILE="$DIR/packages.txt"
if [[ -f "$PKG_FILE" ]]; then
    mapfile -t PKGS < <(grep -v '^\s*#\|^\s*$' "$PKG_FILE")
    log "Packages: ${#PKGS[@]}"
    
    for pkg in "${PKGS[@]}"; do
        log "  → $pkg"
        sudo pacman -S --needed --noconfirm "$pkg" 2>&1 | tee -a "$LOG" || log "  Skipped: $pkg"
    done

    ok "pacman ready"
else
    log "ERROR: $PKG_FILE not found"
fi

section "AUR packages"
AUR_FILE="$DIR/aur.txt"
if [[ -f "$AUR_FILE" ]]; then
    mapfile -t AUR < <(grep -v '^\s*#\|^\s*$' "$AUR_FILE" | grep -v 'chaotic-keyring\|chaotic-mirrorlist')
    log "Packages: ${#AUR[@]}"
    
    for pkg in "${AUR[@]}"; do
        log "  → $pkg"
        yay -S --needed --noconfirm "$pkg" 2>&1 | tee -a "$LOG" || log "  Skipped: $pkg"
    done
    ok "AUR ready"
else
    log "ERROR: $AUR_FILE not found"
fi

section "Flatpak packages"
FLAT_FILE="$DIR/flatpak.txt"
if [[ -f "$FLAT_FILE" ]]; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    mapfile -t FLATS < <(grep -v '^\s*#\|^\s*$' "$FLAT_FILE")
    
    log "Packages: ${#FLATS[@]}"
    for pkg in "${FLATS[@]}"; do
        log "  → $pkg"
        flatpak install --noninteractive flathub "$pkg" 2>&1 | tee -a "$LOG" || \
            log "  Skipped: $pkg"
    done
    
    ok "Flatpak ready"
else
    log "ERROR: $FLAT_FILE not found"
fi

section "Snap packages"
SNAP_FILE="$DIR/snap.txt"
if [[ -f "$SNAP_FILE" ]]; then
    if ! command -v snap &>/dev/null; then
        log "snap not found — please install snapd and reboot"
    else
        mapfile -t SNAPS < <(grep -v '^\s*#\|^\s*$' "$SNAP_FILE" | awk '{print $1}')
        log "Packages: ${#SNAPS[@]}"

        sudo snap install flstudio --channel=latest/candidate 2>&1 | tee -a "$LOG" || true
        
        for pkg in "${SNAPS[@]}"; do
            [[ "$pkg" == "flstudio" ]] && continue
            log "  → $pkg"
            sudo snap install "$pkg" 2>&1 | tee -a "$LOG" || log "  Skipped: $pkg"
        done
        
        ok "Snap ready"
    fi
else
    log "ERROR: $SNAP_FILE not found"
fi

section "Done!"
log "Log: $LOG"
log "NOTE: if snap packages were skipped — enable snapd first:"
log "  sudo systemctl enable --now snapd snapd.socket"
log "  sudo ln -s /var/lib/snapd/snap /snap"
log "  then reboot and re-run the script"