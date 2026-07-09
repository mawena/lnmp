# Référence des commandes

Syntaxe générale :

```
lnmp [COMMANDE / OPTION] [ARGUMENTS]
```

> Toutes les commandes nécessitent les privilèges `root` (via `sudo`).

## Options générales

| Option              | Description                     |
| ------------------- | ------------------------------- |
| `-h`, `--help`      | Afficher l'aide.                |
| `-v`, `--version`   | Afficher la version de l'outil. |

## Commandes globales

### `install`
Installe ou reprend l'installation de la pile (Nginx, MariaDB, PHP, Certbot,
droits `webdev`). Idempotente.

### `uninstall`
Désinstalle et purge la pile et ses composants. **Destructif** — demande une
confirmation.

### `doctor`
Diagnostic complet : état des services (`nginx`, `mariadb`, `php-fpm`), validité
de la configuration Nginx, liste des applications et certificats SSL avec dates
d'expiration.

## Gestion des applications

### `list`
Liste les applications du registre avec leur statut (**Actif** / **Inactif**).

### `add`
Ajoute une application web : demande un **ID**, un **domaine** et un **chemin
absolu**, génère le vhost Nginx, l'active et propose de créer un certificat SSL.
Les entrées sont validées ; si la config Nginx est invalide, le vhost est annulé
automatiquement.

### `enable [id]`
Active une application (lien symbolique dans `sites-enabled`) puis recharge
Nginx sans coupure.

### `disable [id]`
Désactive une application (retire le lien symbolique).

### `delete [id]`
Supprime définitivement le vhost et l'entrée du registre.

### `reload-app`
Reconstruit le registre `/etc/nginx/lnmp_apps.list` à partir des vhosts réels
présents dans `sites-available`.

## Gestion SSL (Let's Encrypt)

### `add-ssl [id]`
Génère un certificat SSL pour le domaine de l'application, avec redirection
HTTPS. Un email (optionnel) peut être fourni pour recevoir les alertes
d'expiration.

### `remove-ssl [id]`
Supprime le certificat SSL de l'application.

## Gestion des bases de données (MariaDB)

### `db-create [nom]`
Crée une base de données (UTF-8 `utf8mb4`) **et** un utilisateur dédié
`<nom>_user` avec un mot de passe généré aléatoirement, affiché une seule fois.

### `db-list`
Liste les bases de données utilisateur (masque les bases système).

### `db-drop [nom]`
Supprime une base de données et son utilisateur associé. Demande confirmation.
