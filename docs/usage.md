# Utilisation

LNMP offre **deux modes** d'utilisation qui partagent exactement les mêmes
fonctions : un menu interactif et des commandes directes scriptables.

## Menu interactif

Lancez `lnmp` sans argument :

```bash
sudo lnmp
```

Un menu numéroté s'affiche (installation, gestion des applications, SSL, bases
de données, diagnostic…). Idéal pour une administration ponctuelle.

## Commandes directes

Chaque action est aussi disponible en ligne de commande, ce qui permet de
scripter et d'automatiser :

```bash
sudo lnmp install
sudo lnmp add
sudo lnmp enable monapp
sudo lnmp add-ssl monapp
sudo lnmp db-create monapp
sudo lnmp doctor
```

## Scénario complet : déployer une application

```bash
# 1. Installer la pile (une seule fois par serveur)
sudo lnmp install

# 2. Ajouter l'application
#    → demande : ID, domaine, chemin absolu du dossier public
sudo lnmp add

# 3. Créer la base de données associée
#    → affiche le nom d'utilisateur et un mot de passe généré (à noter !)
sudo lnmp db-create monapp

# 4. Générer le certificat SSL (le domaine doit déjà pointer vers le serveur)
sudo lnmp add-ssl monapp

# 5. Vérifier l'état global
sudo lnmp doctor
```

## Activer / désactiver sans supprimer

Pour mettre une application hors ligne temporairement (sans perdre sa config) :

```bash
sudo lnmp disable monapp   # Hors ligne
sudo lnmp enable monapp    # De nouveau en ligne
```

## Resynchroniser le registre

Si vous avez édité des vhosts Nginx à la main, réalignez le registre LNMP :

```bash
sudo lnmp reload-app
```
