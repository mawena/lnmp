#!/bin/bash

# Interrompre le script en cas d'erreur
set -e

# Vérification des arguments
if [ $# -lt 2 ]; then
    echo -e "\033[0;31mErreur : Arguments manquants.\033[0m"
    echo "Usage : $0 <version> \"<commentaire>\""
    echo "Exemple : $0 1.4-1 \"Ajout de la commande reload-app\""
    exit 1
fi

VERSION=$1
COMMENTAIRE=$2

# Variables Debian pour dch
export DEBFULLNAME="Charles Gamligo"
export DEBEMAIL="gamligocharles@gmail.com"

echo -e "\033[0;34m=== Début du processus de build pour la version $VERSION ===\033[0m"

# 1. Entrer dans le dossier source
if [ ! -d "packaging" ]; then
    echo -e "\033[0;31mErreur : Le dossier 'packaging' est introuvable.\033[0m"
    exit 1
fi
cd packaging

# 2. Nettoyer le fichier temporaire
rm -f debian/changelog.dch

# 3. Mise à jour du changelog (ignorée si déjà à la version demandée,
#    pour éviter une entrée en double quand le changelog a été édité à la main)
CURRENT_CL_VERSION=$(dpkg-parsechangelog -SVersion 2>/dev/null)
if [ "$CURRENT_CL_VERSION" = "$VERSION" ]; then
    echo -e "\033[1;33m-> Changelog déjà en $VERSION : étape 'dch' ignorée.\033[0m"
else
    echo -e "\033[0;32m-> Mise à jour du changelog ($CURRENT_CL_VERSION -> $VERSION)...\033[0m"
    dch -v "$VERSION" "$COMMENTAIRE"
fi

# 4. Compilation du paquet Debian
echo -e "\033[0;32m-> Compilation du paquet avec debuild...\033[0m"
debuild -us -uc -b

# 5. Revenir au dossier parent
cd ..

# 6. Organiser les fichiers générés dans l'archive locale
echo -e "\033[0;32m-> Archivage local des fichiers générés...\033[0m"
TARGET_DIR="lnmp_${VERSION}"
mkdir -p "$TARGET_DIR"
mv lnmp_${VERSION}* "$TARGET_DIR/" 2>/dev/null || true

mkdir -p archive
rm -rf "archive/$TARGET_DIR" # Nettoyer si une ancienne archive locale du même nom existe
mv "$TARGET_DIR" archive/

# 7. Transfert automatique vers le serveur de production (mawena.cloud)
DEB_FILE="archive/lnmp_${VERSION}/lnmp_${VERSION}_all.deb"
echo -e "\033[0;34m-> Transfert du fichier .deb vers le serveur de prod (Port 2244)...\033[0m"
scp -P 2244 "$DEB_FILE" mawena.cloud:/var/www/html/lnmp/repo/ubuntu/

echo -e "\033[0;32m=== Build v$VERSION terminé, archivé localement et envoyé sur le serveur ! ===\033[0m"
echo -e "Étape suivante : Connectez-vous sur le serveur et lancez : \033[0;33msudo ./update_repo.sh\033[0m"