#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# ibra-bazzite – Script de premier démarrage
# S'exécute une seule fois après l'installation via le service systemd
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

LOG_TAG="ibra-bazzite-firstboot"
SENTINEL="/var/lib/ibra-bazzite/.firstboot-done"

log() { logger -t "$LOG_TAG" "$*"; echo "[ibra-bazzite] $*"; }

log "=== Démarrage de la configuration initiale ==="

# ─── Détection de l'utilisateur humain principal ─────────────────────────────
HUMAN_USER=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65000 {print $1; exit}')
if [ -z "$HUMAN_USER" ]; then
    log "ERREUR : Aucun utilisateur humain détecté. Abandon."
    exit 1
fi
log "Utilisateur détecté : $HUMAN_USER"

# ─── 1. Moonlight – Installation via Flatpak ─────────────────────────────────
log "Installation de Moonlight (Flatpak)..."
flatpak install -y --noninteractive flathub com.moonlight_stream.Moonlight \
    && log "Moonlight installé avec succès." \
    || log "AVERTISSEMENT : Échec de l'installation de Moonlight (réseau ?)"

# ─── 2. Big Picture – Autologin sur la session Gamescope ─────────────────────
log "Configuration de l'autologin Gamescope (Big Picture)..."
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/ibra-autologin.conf <<EOF
[Autologin]
User=${HUMAN_USER}
Session=gamescope-wayland.desktop
Relogin=true
EOF
log "Autologin configuré pour ${HUMAN_USER} -> gamescope-wayland.desktop"

# ─── 3. Moonlight – Ajout dans Steam comme jeu non-Steam ─────────────────────
# Crée un raccourci Steam pour lancer Moonlight depuis Big Picture
STEAM_DIR="/home/${HUMAN_USER}/.local/share/Steam"
if [ -d "$STEAM_DIR" ]; then
    log "Steam détecté – le raccourci Moonlight peut être ajouté manuellement via l'interface."
fi

# ─── 4. Wake-on-LAN – Permissions du dispatcher ──────────────────────────────
chmod +x /etc/NetworkManager/dispatcher.d/99-wake-on-lan
log "Permissions Wake-on-LAN dispatcher fixées."

# ─── Marqueur de fin ─────────────────────────────────────────────────────────
mkdir -p /var/lib/ibra-bazzite
touch "$SENTINEL"
log "=== Configuration initiale terminée avec succès ==="
