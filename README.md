# LNMP — Gestionnaire de pile web pour Ubuntu

[![Licence: MIT](https://img.shields.io/badge/Licence-MIT-blue.svg)](LICENSE)
![Plateforme](https://img.shields.io/badge/Plateforme-Ubuntu-orange.svg)
![Bash](https://img.shields.io/badge/Bash-5.x-4EAA25.svg)
![Python](https://img.shields.io/badge/Python-3-3776AB.svg)

**LNMP** installe et administre une pile web complète sur Ubuntu —
**Nginx + MariaDB + PHP + Certbot (SSL)** — en ligne de commande **ou** depuis
une **interface web** accessible à `http://admin.lnmp`. Gérez des applications,
des domaines multiples (locaux façon Laragon, ou distants), le HTTPS et vos
bases de données en quelques secondes.

---

## ✨ Fonctionnalités

- 🚀 **Installation idempotente** de la pile complète (reprise sur incident).
- 🖥️ **Interface web d'administration** (`admin.lnmp`) : applications, SSL,
  domaines, bases de données, système — protégée par mot de passe.
- 🌐 **Domaines multiples** local/distant ; les domaines locaux mettent à jour
  `/etc/hosts` automatiquement (façon Laragon).
- 🔒 **SSL en un clic** : Let's Encrypt (domaines distants) ou **mkcert**
  (domaines locaux, certificat de confiance locale) — redirection HTTPS auto.
- 🗄️ **Bases de données** : base + utilisateur dédié en une commande.
- 🩺 **Diagnostic** intégré (`doctor`) et sortie **`--json`** scriptable.
- 🖱️ **Trois interfaces** équivalentes : menu interactif, CLI, panneau web.

## 📦 Installation

```bash
# Dépôt APT + installation complète (la pile est installée ET configurée)
echo "deb [trusted=yes] https://mawena.cloud/repo /" | sudo tee /etc/apt/sources.list.d/mawena.list
sudo apt update && sudo apt install lnmp

# Définir le mot de passe du panneau web (non fixé par défaut)
sudo lnmp set-password
```

`apt install lnmp` installe **et configure** toute la pile (Nginx, MariaDB, PHP,
Certbot), déploie le panneau et démarre le démon — rien d'autre à lancer. Le
panneau est ensuite disponible sur `http://admin.lnmp` (ajoutez
`127.0.0.1 admin.lnmp` sur votre poste, ou tunnel SSH pour un VPS — voir
[docs/usage.md](docs/usage.md)). `sudo lnmp install` reste disponible pour une
(re)configuration interactive.

## 🚀 Démarrage rapide

```bash
sudo lnmp domain add test --local     # un domaine local (façon Laragon)
sudo lnmp add --id blog --domain test # http://blog.test, /etc/hosts géré tout seul
sudo lnmp db-create blog              # base + utilisateur MariaDB
sudo lnmp doctor                      # diagnostic
```

Sans argument, `sudo lnmp` ouvre le menu interactif.

## 🖥️ Interface web

Le panneau (`/var/www/html/lnmp`, servi par le vhost `admin.lnmp` lié à
127.0.0.1) est piloté par le démon **`lnmpd`** (API JSON locale, service
systemd `lnmp-admin`). Accès distant recommandé via tunnel SSH :

```bash
ssh -L 8080:127.0.0.1:80 utilisateur@mon-vps   # puis http://localhost:8080
sudo lnmp set-password                          # (ré)initialiser le mot de passe
```

## 📖 Commandes principales

| Commande              | Description                                   |
| --------------------- | --------------------------------------------- |
| `install` / `uninstall` | Installer / désinstaller la pile            |
| `doctor` / `status`   | Diagnostic (ajouter `--json` pour le format machine) |
| `list` / `add`        | Lister / ajouter une application              |
| `enable` / `disable` / `delete` | Gérer un vhost                      |
| `add-ssl` / `remove-ssl` | Certificats Let's Encrypt                  |
| `domain list\|add\|remove` | Gérer les domaines de base (`--local`)   |
| `db-create` / `db-list` / `db-drop` | Bases de données MariaDB        |
| `set-password`        | Mot de passe du panneau web                   |

Documentation complète : dossier [`docs/`](docs/) ou `man lnmp`.

## 🏗️ Architecture

```
lnmp (CLI /usr/bin)  ─┐
                      ├─ logique métier partagée (mode --json)
lnmpd (démon root) ───┘   ← API locale 127.0.0.1, appelée par le panneau web
   ▲
   │ proxy /api/
nginx (vhost admin.lnmp, 127.0.0.1) → panneau statique /var/www/html/lnmp
```

## 🛠️ Développement

Le dépôt est organisé ainsi (voir [CONTRIBUTING.md](CONTRIBUTING.md)) :

```
packaging/   # source du paquet Debian (bin/, sbin/, webui/, systemd/, man/, debian/)
docs/        # documentation Markdown
index.html   # site de présentation (déployable tel quel)
build.sh     # build + envoi du .deb vers le dépôt APT
```

```bash
shellcheck packaging/bin/lnmp
python3 -m py_compile packaging/sbin/lnmpd
./build.sh 1.9-1 "Description de la nouveauté"
```

## 🌐 Site de présentation

`index.html` est une page autonome (aucune dépendance externe) : déposez-la sur
un serveur web pour publier la documentation.

```bash
python3 -m http.server 8000   # aperçu local sur http://localhost:8000
```

## 📄 Licence

Distribué sous licence [MIT](LICENSE). © 2026 Charles Gamligo.
