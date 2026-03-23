# 🎮 ibra-bazzite

Image Bazzite KDE personnalisée, optimisée pour un usage **console de jeu** sur PC fixe ou mini-PC.

Basée sur [ublue-os/bazzite](https://github.com/ublue-os/bazzite) · Construite automatiquement via GitHub Actions · Distribuée sur `ghcr.io`

---

## ✨ Ce qui est inclus

| Composant | Description |
|---|---|
| **Bazzite KDE** | Base stable, compatible Steam Deck Big Picture |
| **Gamescope (Big Picture)** | Session par défaut au démarrage, autologin configuré |
| **Wake-on-LAN** | Activé automatiquement sur chaque interface Ethernet |
| **Tailscale** | VPN mesh WireGuard, démarrage automatique |
| **Ollama** | Serveur LLM local (port 11434), service systemd dédié |
| **Moonlight** | Client de streaming de jeux (installé via Flatpak au 1er boot) |

---

## 🚀 Installation

### Étape 1 — Installer Bazzite standard

Télécharge et flashe l'image officielle Bazzite KDE avec [Balena Etcher](https://etcher.balena.io/) :

```
https://bazzite.gg
```

Installe normalement, crée ton compte utilisateur, redémarre.

---

### Étape 2 — Rebase vers ibra-bazzite

Ouvre un terminal et lance :

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/TON_GITHUB_USER/ibra-bazzite:latest
```

> Remplace `TON_GITHUB_USER` par ton nom d'utilisateur GitHub.

Puis redémarre :

```bash
systemctl reboot
```

Au redémarrage, le service `ibra-bazzite-firstboot` s'exécute automatiquement et :
- installe Moonlight via Flatpak
- configure l'autologin sur la session Gamescope (Big Picture)

---

### Étape 3 — Connecter Tailscale (une seule fois)

```bash
sudo tailscale up
```

Ouvre le lien affiché dans un navigateur pour t'authentifier sur ton compte Tailscale.

---

### Étape 4 — Activer Wake-on-LAN dans le BIOS

Dans le BIOS/UEFI de ta machine, active l'option **Wake on LAN** (parfois appelée *Power On by PCI-E* ou *ErP Ready → Disabled*).

Le dispatcher NetworkManager inclus s'occupe du reste automatiquement.

---

## 🔧 Mise à jour de l'image

Les mises à jour Bazzite sont appliquées en rebasant vers la dernière version de l'image :

```bash
rpm-ostree upgrade
# ou
ujust update
```

L'image est reconstruite automatiquement **chaque lundi à 6h UTC** via GitHub Actions.

---

## 🤖 Ollama – Modèles LLM

Après installation, télécharge un modèle :

```bash
ollama pull llama3
ollama run llama3
```

L'API REST est disponible localement sur `http://localhost:11434` et accessible depuis ton réseau Tailscale.

---

## 🎮 Moonlight – Streaming de jeux

Moonlight est installé au premier boot. Pour l'utiliser :

1. Installe [Sunshine](https://github.com/LizardByte/Sunshine) sur la machine qui diffuse
2. Depuis Big Picture > Bibliothèque > Ajouter un jeu non-Steam → sélectionne Moonlight
3. Lance Moonlight depuis ta manette

---

## 📁 Structure du projet

```
ibra-bazzite/
├── Containerfile                            # Image OCI – définition principale
├── REBASE.sh                                # Script de rebase post-install
├── .github/
│   └── workflows/
│       └── build.yml                        # Build & push GitHub Actions
└── config/
    └── files/                               # Overlay sur le système de fichiers
        ├── etc/
        │   ├── sddm.conf.d/                 # (généré au 1er boot)
        │   └── NetworkManager/dispatcher.d/
        │       └── 99-wake-on-lan           # Activation WoL automatique
        └── usr/lib/
            ├── systemd/system/
            │   ├── ollama.service           # Service Ollama
            │   └── ibra-bazzite-firstboot.service
            └── ibra-bazzite/
                └── firstboot.sh             # Config 1er démarrage
```

---

## 🛠️ Personnalisation

Pour modifier l'image (ajouter des paquets, changer la config) :

1. Édite le `Containerfile`
2. Pousse sur `main` → GitHub Actions rebuild automatiquement
3. Lance `rpm-ostree upgrade` sur ta machine pour récupérer la nouvelle image

---

## 🔗 Ressources

- [Documentation Bazzite](https://docs.bazzite.gg)
- [ublue-os/image-template](https://github.com/ublue-os/image-template)
- [Tailscale](https://tailscale.com/kb)
- [Ollama](https://ollama.com/library)
- [Moonlight](https://github.com/moonlight-stream/moonlight-qt)
- [Sunshine (serveur streaming)](https://github.com/LizardByte/Sunshine)
