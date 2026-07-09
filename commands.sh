cd files
rm -f debian/changelog.dch;
dch -v 1.4-1 "Ajout de la commande 'reload-app' pour synchroniser le registre et support complet des commandes directes en ligne de commande (add, delete, enable, disable).";
debuild -us -uc -b; #Lancer le build dans le dossier files
cd ..;
mkdir lnmp_1.4-1;
mv lnmp_1.4-1* lnmp_1.4-1/
mv lnmp_1.4-1 archive/; #Déplacer les fichiers générés dans le dossier 1.4-1

scp -P 2244 archive/lnmp_1.4-1/lnmp_1.4-1_all.deb mawena.cloud:/var/www/html/mawena.cloud/repo/ubuntu	#Envoyer le fichier .deb sur le serveur distant
#echo "deb [trusted=yes lang=none] https://mawena.cloud/repo /" | sudo tee /etc/apt/sources.list.d/mawena.list #Ajoute le dépôt à la liste des sources APT
#sudo apt update #Met à jour la liste des paquets disponibles
#sudo apt install lnmp #Installe le paquet lnmp depuis le dépôt distant