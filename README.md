# LNMP — Gestionnaire CLI pour pile web Ubuntu

[![Licence: MIT](https://img.shields.io/badge/Licence-MIT-blue.svg)](LICENSE)
![Plateforme](https://img.shields.io/badge/Plateforme-Ubuntu-orange.svg)
![Bash](https://img.shields.io/badge/Bash-5.x-4EAA25.svg)

**LNMP** est un outil d'administration en ligne de commande qui installe et gère
une pile web complète sur Ubuntu : **Nginx + MariaDB + PHP + Certbot (SSL)**.
En quelques commandes, déployez une nouvelle application web, activez son
certificat HTTPS et provisionnez sa base de données.

---

## ✨ Fonctionnalités

- 🚀 **Installation idempotente** de la pile complète (reprise sur incident).
- 🌐 **Gestion des applications** : création de vhosts Nginx, activation/désactivation, suppression.
- 🔒 **SSL en un clic** via Let's Encrypt (Certbot) avec redirection HTTPS.
- 🗄️ **Bases de données** : création de base + utilisateur dédié (MariaDB).
- 🩺 **Diagnostic** intégré (`doctor`) : services, config Nginx, certificats.
- 🖥️ **Double interface** : menu interactif **ou** commandes directes scriptables.

## 📦 Installation

### Via le dépôt APT (recommandé)

```bash
echo "deb [trusted=yes lang=none] https://mawena.cloud/repo /" | sudo tee /etc/apt/sources.list.d/mawena.list
sudo apt update
sudo apt install lnmp
```

### Via un fichier .deb

```bash
sudo apt install ./lnmp_1.7-1_all.deb
```

## 🚀 Démarrage rapide

```bash
# 1. Installer la pile (Nginx, MariaDB, PHP, Certbot)
sudo lnmp install

# 2. Ajouter une application web (vhost + activation)
sudo lnmp add

# 3. Provisionner sa base de données
sudo lnmp db-create monapp

# 4. Vérifier que tout tourne
sudo lnmp doctor
```

Lancé **sans argument**, `lnmp` ouvre un menu interactif :

```bash
sudo lnmp
```

## 📖 Commandes principales

| Commande            | Description                                        |
| ------------------- | -------------------------------------------------- |
| `install`           | Installer / reprendre l'installation de la pile    |
| `uninstall`         | Désinstaller complètement la pile                  |
| `doctor`            | Diagnostiquer l'état de la pile                    |
| `list`              | Lister les applications web                        |
| `add`               | Ajouter une application web                        |
| `enable [id]`       | Activer une application                            |
| `disable [id]`      | Désactiver une application                         |
| `delete [id]`       | Supprimer une application                          |
| `add-ssl [id]`      | Générer un certificat SSL Let's Encrypt            |
| `remove-ssl [id]`   | Retirer un certificat SSL                          |
| `reload-app`        | Reconstruire le registre depuis Nginx              |
| `db-create [nom]`   | Créer une base + utilisateur MariaDB               |
| `db-list`           | Lister les bases de données                        |
| `db-drop [nom]`     | Supprimer une base de données                      |

> Documentation complète : voir le dossier [`docs/`](docs/) ou la page de man
> `man lnmp` après installation.

## ⚙️ Prérequis

- Ubuntu (22.04+ recommandé) avec accès `root`/`sudo`.
- Un nom de domaine pointant vers le serveur (pour les certificats SSL).

## 🛠️ Développement & contribution

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour l'organisation du dépôt, la
convention de commits et le processus de release.

```bash
# Vérifier le script
shellcheck files/bin/lnmp

# Construire le paquet
./build.sh 1.8-1 "Description de la nouveauté"
```

## 📄 Licence

Distribué sous licence [MIT](LICENSE). © 2026 Charles Gamligo.
