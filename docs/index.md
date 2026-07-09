# Documentation LNMP

Bienvenue dans la documentation de **LNMP**, le gestionnaire CLI de pile web
pour Ubuntu (Nginx + MariaDB + PHP + Certbot).

## Sommaire

1. [Installation](installation.md) — installer LNMP via le dépôt APT ou un `.deb`.
2. [Utilisation](usage.md) — menu interactif, commandes directes, exemples.
3. [Référence des commandes](commands.md) — description détaillée de chaque commande.
4. [Configuration & fichiers](configuration.md) — registre, état, structure Nginx.
5. [FAQ & dépannage](faq.md) — problèmes courants et solutions.

## En bref

```bash
sudo lnmp install        # Installer la pile
sudo lnmp add            # Ajouter une application
sudo lnmp db-create app  # Créer sa base de données
sudo lnmp doctor         # Diagnostiquer
```

> LNMP doit être exécuté avec les privilèges `root` (via `sudo`).
