# Utilisation

LNMP offre **trois interfaces** qui partagent exactement les mêmes fonctions :
un menu interactif, des commandes directes scriptables, et un panneau web.

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

## Domaines multiples (façon Laragon)

Déclarez les domaines de base, puis choisissez-les à l'ajout d'une application.

```bash
sudo lnmp domain add test --local          # domaine local -> /etc/hosts géré
sudo lnmp domain add mawena.cloud          # domaine distant
sudo lnmp add --id blog --domain test      # http://blog.test
sudo lnmp add --id shop --domain mawena.cloud --apex   # http://mawena.cloud
```

Pour un domaine marqué **local**, LNMP ajoute et retire tout seul les entrées
`/etc/hosts` (`127.0.0.1 blog.test`) à la création et à la suppression de l'app.

## Panneau web d'administration

L'installation déploie un panneau sur **`http://admin.lnmp`** (lié à
127.0.0.1). Il couvre les mêmes actions : applications, SSL, domaines, bases de
données et opérations système.

- **En local** : ajoutez `127.0.0.1 admin.lnmp` au fichier `hosts` de votre
  poste, puis ouvrez `http://admin.lnmp`.
- **Sur un VPS** : passez par un tunnel SSH (le panneau n'est jamais exposé
  directement à Internet) :

  ```bash
  ssh -L 8080:127.0.0.1:80 utilisateur@mon-vps
  # puis ouvrez http://localhost:8080
  ```

Le panneau exige une authentification. Pour (ré)initialiser le mot de passe :

```bash
sudo lnmp set-password
```

## Resynchroniser le registre

Si vous avez édité des vhosts Nginx à la main, réalignez le registre LNMP :

```bash
sudo lnmp reload-app
```
