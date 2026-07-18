# ⚠️ Aide-mémoire — préférez désormais ./build.sh <version> "<commentaire>"
# qui automatise tout le processus ci-dessous (build, archivage, envoi serveur).
#
# Étapes manuelles équivalentes (source du paquet dans packaging/) :

cd packaging
rm -f debian/changelog.dch;
dch -v 1.7-1 "Description de la nouveauté";
debuild -us -uc -b; # Lancer le build dans le dossier packaging
cd ..;
mkdir -p lnmp_1.7-1;
mv lnmp_1.7-1* lnmp_1.7-1/
mv lnmp_1.7-1 archive/; # Déplacer les fichiers générés dans le dossier de version

scp -P 2244 archive/lnmp_1.7-1/lnmp_1.7-1_all.deb mawena.cloud:/var/www/html/mawena.cloud/repo/ubuntu	# Envoyer le .deb sur le serveur
#echo "deb [trusted=yes lang=none] https://mawena.cloud/repo /" | sudo tee /etc/apt/sources.list.d/mawena.list # Ajoute le dépôt APT
#sudo apt update # Met à jour la liste des paquets
#sudo apt install lnmp # Installe le paquet lnmp
