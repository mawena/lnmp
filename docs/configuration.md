# Configuration & fichiers

## Fichiers gérés par LNMP

| Fichier                              | Rôle                                                        |
| ------------------------------------ | ----------------------------------------------------------- |
| `/etc/nginx/lnmp_apps.list`          | Registre des applications (`id:fqdn:chemin:domaine_base`).  |
| `/etc/lnmp/lnmp.conf`                | Domaine par défaut, PHP, port du démon, hôte + interface du panneau (`ADMIN_HOST`, `ADMIN_LISTEN`). |
| `/etc/lnmp/domains.list`             | Domaines de base (`nom:local\|remote`).                     |
| `/etc/lnmp/admin.conf`               | Hash du mot de passe + secret de session (root, `600`).     |
| `/var/log/lnmp_install_state`        | Étape d'installation atteinte (reprise sur incident, 0–8).  |
| `/etc/nginx/sites-available/<id>`    | Configuration vhost de chaque application.                  |
| `/etc/nginx/sites-enabled/<id>`      | Lien symbolique = application active.                       |
| `/usr/share/lnmp/public`             | Panneau web statique (fourni par le paquet, lecture seule). |
| `/var/www/lnmp`                      | Symlink d'exposition → `/usr/share/lnmp/public` (vhost `admin.lnmp`). |

## Format du registre

Chaque ligne décrit une application :

```
blog:blog.mawena.cloud:/var/www/html/blog/public:mawena.cloud
```

- **id** — identifiant unique (aussi le nom du fichier vhost) ;
- **fqdn** — `server_name` Nginx complet ;
- **chemin** — dossier `root` servi ;
- **domaine_base** — domaine de base choisi (pour la gestion `/etc/hosts`).

## Structure d'un vhost généré

```nginx
server {
    listen 80;
    server_name app.mawena.cloud;
    root /var/www/html/MonApp/public;
    index index.html index.php;
    charset utf-8;
    location / { try_files $uri $uri/ /index.php?$query_string; }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
    }
}
```

Après `add-ssl`, Certbot ajoute automatiquement le bloc `listen 443 ssl` et la
redirection HTTP → HTTPS.

## Droits & groupe `webdev`

À l'installation, LNMP crée le groupe **`webdev`**, y ajoute l'utilisateur
courant et `www-data`, puis applique des ACL sur `/var/www/html` pour un travail
collaboratif (droits de groupe hérités, `setgid`).

## Version de PHP

La version de PHP est centralisée dans la variable `PHP_VERSION` en tête du
script (`8.3` par défaut). Pour changer de version majeure, modifiez cette
variable — toutes les références (paquets, socket FPM, vhosts) suivent.
