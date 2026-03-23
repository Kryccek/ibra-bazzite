#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# REBASE vers ibra-bazzite
# À exécuter UNE SEULE FOIS après avoir installé le Bazzite standard
# Remplacez TON_GITHUB_USER par votre nom d'utilisateur GitHub
# ─────────────────────────────────────────────────────────────────────────────

GITHUB_USER="TON_GITHUB_USER"
IMAGE="ghcr.io/${GITHUB_USER}/ibra-bazzite:latest"

echo "==> Rebase vers l'image personnalisée : $IMAGE"
echo "==> Le système redémarrera automatiquement après le rebase."
echo ""

# Rebase vers votre image OCI personnalisée
rpm-ostree rebase "ostree-unverified-registry:${IMAGE}"

echo ""
echo "==> Rebase planifié. Redémarrez pour appliquer :"
echo "    systemctl reboot"
