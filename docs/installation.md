# Installation

## Prérequis

- **Ubuntu 22.04+** (ou dérivé) avec accès `root` / `sudo`.
- Une connexion Internet (téléchargement des paquets).
- Pour le SSL : un **nom de domaine** pointant (enregistrement A/AAAA) vers l'IP
  publique du serveur.

## Méthode 1 — Dépôt APT (recommandée)

Ajoutez le dépôt Mawena, mettez à jour la liste des paquets, puis installez :

```bash
echo "deb [trusted=yes lang=none] https://mawena.cloud/repo /" | sudo tee /etc/apt/sources.list.d/mawena.list
sudo apt update
sudo apt install lnmp
```

Les mises à jour se feront ensuite naturellement avec `sudo apt upgrade`.

## Méthode 2 — Fichier .deb autonome

Si vous disposez du fichier `.deb` :

```bash
sudo apt install ./lnmp_1.7-1_all.deb
```

`apt` installera automatiquement les dépendances (`nginx`, `mariadb-server`,
`certbot`, etc.).

## Vérifier l'installation

```bash
lnmp --version
man lnmp
```

## La pile est installée automatiquement

`apt install lnmp` **installe et configure la pile complète** (Nginx, MariaDB,
PHP, Certbot), déploie le panneau web et démarre le démon d'administration. Il
n'y a rien d'autre à lancer.

Il ne reste qu'à **définir le mot de passe** du panneau (non fixé par défaut,
pour des raisons de sécurité) :

```bash
sudo lnmp set-password
```

Le panneau est alors accessible sur **`http://admin.lnmp`** (voir
[usage.md](usage.md#panneau-web-dadministration) pour l'accès local ou par
tunnel SSH, et pour choisir un autre lien/interface avec `lnmp admin-url`).

### Réinstaller / reconfigurer manuellement

`sudo lnmp install` reste disponible (menu ou ligne de commande) pour
(re)configurer la pile de façon interactive — il demande le domaine par défaut,
le mot de passe et l'interface du panneau. La commande est **idempotente**.

## Désinstallation

```bash
# Option 1 — via apt (retire lnmp + le service web via les scripts du paquet)
sudo apt purge lnmp          # + suppression de /etc/lnmp
sudo apt autoremove          # retire aussi les dépendances devenues inutiles

# Option 2 — via lnmp (sélectif : garde Nginx/MariaDB/PHP par défaut, puis
# retire le paquet lnmp lui-même)
sudo lnmp uninstall
```
