# Design — LNMP : domaines multiples + interface web d'administration

Date : 2026-07-18
Statut : approuvé (implémentation par phases)

## 1. Objectif

Faire évoluer LNMP d'un CLI mono-serveur vers un outil qui :

1. gère **plusieurs domaines de base** (locaux façon Laragon, ou distants) ;
2. offre une **interface web d'administration** (`http://admin.lnmp`) couvrant
   toutes les actions du menu terminal, la gestion des domaines et des bases de
   données ;
3. s'installe et se configure **automatiquement** pendant `lnmp install`
   (domaine par défaut + mot de passe admin demandés).

## 2. Principe directeur

**Le démon réutilise le CLI, il ne le duplique pas.** Chaque action privilégiée
est exécutée via `lnmp <commande> --json`. Le CLI devient entièrement
scriptable ; il sert trois consommateurs partageant la même logique : le menu
terminal interactif, la ligne de commande, et le démon web.

## 3. Composants

| Composant        | Emplacement installé          | Rôle |
| ---------------- | ----------------------------- | ---- |
| `lnmp` (CLI)     | `/usr/bin/lnmp`               | Logique métier, scriptable, mode `--json`. |
| `lnmpd` (démon)  | `/usr/sbin/lnmpd` (Python 3)  | Service systemd, API JSON sur `127.0.0.1:8787`, auth. Relaie vers le CLI. |
| Panneau web      | `/var/www/html/lnmp`          | SPA statique (login + tableau de bord). Appelle `/api/*`. |
| vhost admin      | `/etc/nginx/sites-*/admin.lnmp` | `listen 127.0.0.1:80`, sert le panneau, proxy `/api/` → démon. |
| Config           | `/etc/lnmp/`                  | `lnmp.conf`, `domains.list`, `admin.conf`. |

### Fichiers de configuration `/etc/lnmp/`

- `lnmp.conf` — `DEFAULT_DOMAIN`, `PHP_VERSION`, `ADMIN_PORT`.
- `domains.list` — une ligne par domaine de base : `nom:type` (`local`|`remote`).
- `admin.conf` — `PASSWORD_HASH` (PBKDF2), `SESSION_SECRET`. `chmod 600`, root.
- `/etc/nginx/lnmp_apps.list` — registre étendu : `id:fqdn:chemin:domaine_base`.

## 4. Flux de données (exemple : ajout d'app via le web)

```
Navigateur (tunnel SSH)
  → nginx admin.lnmp:80 (127.0.0.1)
    → panneau statique  →  POST /api/apps  (cookie session)
      → nginx proxy /api/ → lnmpd 127.0.0.1:8787
        → vérifie session → subprocess: lnmp add --json --id blog --domain test --path /var/www/html/blog/public
          → écrit le vhost + registre + /etc/hosts (si domaine local) + reload_nginx
        ← JSON {ok, app}
      ← JSON
    ← rafraîchit la liste
```

## 5. Domaines multiples (façon Laragon)

- Un **registre de domaines de base**, chacun `local` ou `remote`.
- Ajout d'app : choix du domaine de base → FQDN = `<id>.<domaine>` (apex
  possible via `--apex`). Domaine `local` → entrée `/etc/hosts`
  (`127.0.0.1  blog.test`) ajoutée à la création, retirée à la suppression.
- Commandes CLI : `lnmp domain list|add <nom> [--local]|remove <nom>`.
- `lnmp install` demande le **domaine par défaut** (proposé par défaut à l'ajout
  d'app) et le **mot de passe admin**.

## 6. API du démon (`lnmpd`)

Toutes les réponses sont en JSON. Auth par cookie de session (sauf `/api/login`).

| Méthode | Route                    | Action |
| ------- | ------------------------ | ------ |
| POST    | `/api/login`             | Authentifier, poser le cookie de session. |
| POST    | `/api/logout`            | Invalider la session. |
| GET     | `/api/status`            | État de la pile (services, config, SSL). |
| GET     | `/api/apps`              | Lister les applications. |
| POST    | `/api/apps`              | Ajouter une application. |
| POST    | `/api/apps/{id}/enable`  | Activer. |
| POST    | `/api/apps/{id}/disable` | Désactiver. |
| DELETE  | `/api/apps/{id}`         | Supprimer. |
| POST    | `/api/apps/{id}/ssl`     | Générer un certificat SSL. |
| DELETE  | `/api/apps/{id}/ssl`     | Retirer le certificat. |
| GET     | `/api/domains`           | Lister les domaines de base. |
| POST    | `/api/domains`           | Ajouter un domaine (`local`/`remote`). |
| DELETE  | `/api/domains/{name}`    | Retirer un domaine. |
| GET     | `/api/databases`         | Lister les bases. |
| POST    | `/api/databases`         | Créer une base + utilisateur. |
| DELETE  | `/api/databases/{name}`  | Supprimer une base. |
| POST    | `/api/system/reload`     | `reload-app` (resynchroniser le registre). |
| POST    | `/api/system/uninstall`  | Désinstaller la pile (confirmation requise). |

Le démon **ne construit jamais de chaîne shell** : il appelle `subprocess.run`
avec une liste d'arguments et lit le JSON renvoyé par le CLI.

## 7. Panneau web

SPA statique (aucune dépendance externe, tout inline). Écrans :

- **Login** — mot de passe.
- **Tableau de bord** — état des services (pastilles), raccourcis.
- **Applications** — table (statut, domaine), actions activer/désactiver/
  supprimer/SSL, formulaire d'ajout (choix du domaine de base).
- **Domaines** — liste local/distant, ajout/suppression.
- **Bases de données** — liste, création (affiche identifiants une fois),
  suppression.
- **Système** — install/état, reload-app, désinstallation.

Ergonomie : navigation latérale, toasts de retour, confirmations pour les
actions destructrices. Style aligné sur la vitrine (encre bleu-nuit, accent
corail, statut émeraude).

## 8. Sécurité

- Démon **et** vhost admin liés à `127.0.0.1` uniquement ; accès distant par
  tunnel SSH (`ssh -L 8080:127.0.0.1:80 vps`).
- **Authentification obligatoire** : mot de passe PBKDF2 (hashlib), sel + secret
  de session aléatoires générés à l'install. Cookie `HttpOnly`, `SameSite=Strict`.
- **Limitation des tentatives** de login (backoff après N échecs).
- Validation stricte de toutes les entrées côté CLI *et* démon ; arguments
  passés en liste (pas d'`eval`/shell).
- Durcissement systemd du démon (`ProtectHome`, `ProtectSystem`, `NoNewPrivileges`
  dans la mesure compatible avec la gestion de nginx/systemctl).
- `uninstall` retire panneau, démon, unité systemd, vhost admin, entrées
  `/etc/hosts` et config.

## 9. Réorganisation du dépôt

`files/` (racine source du paquet) → `packaging/` :

```
lnmp/
├── packaging/
│   ├── bin/lnmp
│   ├── sbin/lnmpd
│   ├── webui/                 # → /var/www/html/lnmp
│   ├── systemd/lnmp-admin.service
│   ├── man/lnmp.1
│   └── debian/                # control, rules, *.install, copyright, changelog
├── docs/
├── web/                       # vitrine (présentation + doc install & usage)
├── build.sh, README.md, LICENSE, CONTRIBUTING.md
```

`build.sh` et `commands.sh` mis à jour (`cd packaging`). Les chemins
`debian/*.install` restent relatifs à la racine source (`packaging/`).

## 10. Découpage en phases

1. **Fondations** — réorg `files/`→`packaging/`, config `/etc/lnmp`, prompt
   domaine par défaut + mot de passe admin à l'install, CLI scriptable + `--json`.
2. **Domaines multiples** — registre, `lnmp domain *`, `/etc/hosts`, `add` avec
   choix de domaine, registre d'apps étendu.
3. **Démon + API** — `lnmpd` (Python), unité systemd, auth, endpoints.
4. **Panneau web** — SPA, vhost `admin.lnmp`, câblage install/uninstall.
5. **Vitrine & docs** — page de présentation enrichie (doc install/usage), mise
   à jour `docs/`, page de man, README.

## 11. Tests & gestion d'erreurs

- CLI : `bats` (validation, domaines, ajout d'app, mode `--json`).
- Démon : `unittest` Python (auth, routage, refus sans session), avec `lnmp`
  mocké.
- CI : `shellcheck` + `bash -n` + `python3 -m compileall` + build `.deb`.
- Erreurs : API renvoie `{ok:false, error}` structuré → toasts ; échec
  `nginx -t` → rollback du vhost ; actions destructrices confirmées.

## 12. Dépendances ajoutées au paquet

`python3` (déjà présent via `certbot`), rendu explicite dans `debian/control`.

## 13. Hors périmètre (YAGNI)

- Multi-utilisateurs / rôles (un seul mot de passe admin).
- HTTPS natif du panneau (accès via tunnel ; exposition publique = évolution
  ultérieure documentée).
- Gestion PHP multi-versions simultanées (une version via `PHP_VERSION`).
