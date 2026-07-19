#!/bin/bash

# Interrompre le script en cas d'erreur inattendue
set -e

# Couleurs pour l'affichage
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${GREEN}    INITIALISATION DE L'INSTALLATEUR CLIENT LNMP     ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# 1. Vérification des privilèges Root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Erreur : Ce script doit être exécuté en tant que root.${NC}"
    echo "Veuillez relancer avec : wget -qO- https://lnmp.mawena.cloud/install.sh | sudo sh"
    exit 1
fi

# 2. Vérification de la distribution (Doit être Ubuntu)
if [ ! -f /etc/os-release ] || ! grep -qi "ubuntu" /etc/os-release; then
    echo -e "${RED}Erreur : Ce script est exclusivement conçu pour les systèmes Ubuntu.${NC}"
    exit 1
fi

# 3. Configuration de la source APT (Utilisation du dépôt plat './')
echo -e "${YELLOW}-> Ajout du dépôt mawena.cloud aux sources APT...${NC}"
echo "deb [trusted=yes lang=none] https://lnmp.mawena.cloud/repo ./" | tee /etc/apt/sources.list.d/mawena.list

# 4. Nettoyage et rafraîchissement des index APT
echo -e "${YELLOW}-> Nettoyage et mise à jour des catalogues de paquets...${NC}"
rm -f /var/lib/apt/lists/*mawena*
apt-get update -o Acquire::http::No-Cache=true

# 5. Installation du paquet LNMP
echo -e "${YELLOW}-> Installation du gestionnaire LNMP depuis le dépôt distant...${NC}"
# Le drapex -y permet d'automatiser la validation sans bloquer le script
apt-get install -y lnmp

echo -e "${BLUE}-----------------------------------------------------${NC}"
echo -e "${GREEN}Félicitations ! L'outil LNMP a été installé avec succès.${NC}"
echo -e "Vous pouvez maintenant l'exécuter en tapant : ${BLUE}sudo lnmp${NC}"
echo -e "${BLUE}=====================================================${NC}"
