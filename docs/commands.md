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
| `--json`            | Sortie JSON (scripts / démon web). |

## Commandes globales

### `install`
Installe ou reprend l'installation de la pile (Nginx, MariaDB, PHP, Certbot,
droits `webdev`). Idempotente.

### `uninstall`
Désinstallation **sélective**. Par défaut, seul le service web d'administration
LNMP est retiré ; **Nginx, MariaDB, PHP et vos applications sont conservés**
(ce qui évite de casser `/etc/nginx`). En interactif, chaque composant est
proposé. Options non interactives : `--nginx`, `--mariadb`, `--php`, `--apps`,
`--yes`.

### `doctor`
Diagnostic complet : état des services (`nginx`, `mariadb`, `php-fpm`,
`lnmp-admin`), validité de la configuration Nginx, domaines, applications et
certificats SSL avec dates d'expiration.

### `status`
État synthétique, particulièrement utile avec `--json` (consommé par le panneau
web).

## Gestion des applications

### `list`
Liste les applications du registre avec leur statut (**Actif** / **Inactif**).

### `add`
Ajoute une application web : demande un **ID**, un **domaine de base** (parmi
les domaines enregistrés) et un **chemin**, génère le vhost Nginx, l'active et
propose un certificat SSL. Le FQDN est `<id>.<domaine>` par défaut.
Options : `--id`, `--domain`, `--sub`, `--apex` (utiliser le domaine racine),
`--path`. Si le domaine est local, l'entrée `/etc/hosts` est créée
automatiquement. Les entrées sont validées ; en cas de config Nginx invalide,
le vhost est annulé.

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

## Gestion des domaines

### `domain list`
Liste les domaines de base et leur type (`local` / distant), avec le domaine par
défaut.

### `domain add <nom>`
Ajoute un domaine de base. `--local` le marque comme local : les FQDN des
applications sur ce domaine sont ajoutés à `/etc/hosts` automatiquement.

### `domain remove <nom>`
Retire un domaine de base du registre.

## Interface web

### `set-password`
Définit ou réinitialise le mot de passe du panneau web (`http://admin.lnmp`).
Le mot de passe est stocké haché (PBKDF2) dans `/etc/lnmp/admin.conf`.

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

### `db-dump [nom]`
Sauvegarde une base dans un fichier. Sans `--path`, écrit un fichier horodaté et
compressé dans `/var/backups/lnmp/` (`<nom>-<AAAAMMJJ-HHMMSS>.sql.gz`). Avec
`--path <fichier>`, l'extension `.gz` déclenche la compression, sinon SQL brut.

```bash
sudo lnmp db-dump blog                              # /var/backups/lnmp/blog-….sql.gz
sudo lnmp db-dump blog --path /srv/backups/blog.sql # SQL non compressé
```

### `db-import [nom] [fichier]`
Importe une base depuis un fichier `.sql` ou `.sql.gz` (détection par
l'extension). La base cible est créée si elle n'existe pas. `--yes` saute la
confirmation, `--path` remplace l'argument fichier.

```bash
sudo lnmp db-import blog /var/backups/lnmp/blog-20260720-101500.sql.gz
```
