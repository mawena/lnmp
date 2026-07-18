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

## Installer la pile LNMP

L'installation du **paquet** ne fait que déposer l'outil. Pour installer et
configurer la **pile** (Nginx, MariaDB, PHP, Certbot) :

```bash
sudo lnmp install
```

L'installation vous demande le **domaine par défaut** (ex. `mawena.cloud`, ou
`test` pour du local) et le **mot de passe du panneau web**. Elle est
**idempotente** : en cas d'interruption, relancez la même commande — elle
reprend à la dernière étape réussie (état stocké dans
`/var/log/lnmp_install_state`).

À la fin, le panneau d'administration est accessible sur **`http://admin.lnmp`**
(voir [usage.md](usage.md#panneau-web-dadministration) pour l'accès local ou par
tunnel SSH).

## Désinstallation

```bash
sudo lnmp uninstall      # Retire la pile et ses composants
sudo apt remove lnmp     # Retire l'outil lnmp lui-même
```
