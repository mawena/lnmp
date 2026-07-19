#!/bin/bash
# =============================================================================
# update_repo.sh — régénère l'index APT du dépôt « flat » MULTI-PAQUETS.
#
# Emplacement prévu sur le serveur : /var/www/html/Mawena/mawena/repo/update_repo.sh
# URL publique                     : https://mawena.cloud/repo
# Ligne APT côté client            : deb [trusted=yes] https://mawena.cloud/repo /
#
# Le dossier ubuntu/ contient TOUS les .deb (lnmp, dnsmasq-webui, futurs
# paquets). dpkg-scanpackages les indexe tous d'un coup : un seul dépôt sert
# donc « apt install lnmp », « apt install dnsmasq-webui », etc.
#
# Prérequis serveur : sudo apt install dpkg-dev apt-utils
# À lancer après chaque dépôt de .deb dans ubuntu/.
# =============================================================================
set -e

REPO_DIR="/var/www/html/Mawena/mawena/repo"
cd "$REPO_DIR"

# 1. Index des paquets — chemins relatifs à la racine du dépôt (ubuntu/xxx.deb)
dpkg-scanpackages ubuntu /dev/null > Packages
gzip -kf Packages

# 2. Fichier Release (à la racine du dépôt)
apt-ftparchive release . > Release

echo "Dépôt régénéré : $(grep -c '^Package:' Packages) paquet(s) indexé(s)."
grep '^Package:' Packages | sed 's/^/  - /'
