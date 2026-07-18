# Contribuer à LNMP

Merci de votre intérêt pour le projet ! Ce document décrit l'organisation du
dépôt et le processus de publication d'une nouvelle version.

## Structure du dépôt

```
lnmp/
├── packaging/              # Sources du paquet Debian (racine debhelper)
│   ├── bin/lnmp            # CLI principal (logique métier, mode --json)
│   ├── sbin/lnmpd          # Démon d'administration (API JSON, Python)
│   ├── webui/              # Panneau web statique → /var/www/html/lnmp
│   ├── systemd/            # Unité lnmp-admin.service
│   ├── man/lnmp.1          # Page de manuel
│   └── debian/             # Métadonnées de packaging (control, rules, changelog…)
├── docs/                   # Documentation Markdown
├── index.html             # Site de présentation statique (déployable)
├── build.sh                # Script de build + envoi vers le dépôt APT
└── .github/workflows/      # Intégration continue
```

## Prérequis de développement

```bash
sudo apt install devscripts debhelper build-essential shellcheck
```

## Boucle de développement

1. Modifier `packaging/bin/lnmp` (ou la doc).
2. Vérifier le script : `shellcheck packaging/bin/lnmp`.
3. Tester localement l'installation du `.deb` généré dans une VM/conteneur
   Ubuntu (le script exige `root` et modifie Nginx/MariaDB — **ne jamais tester
   sur une machine de production**).

## Convention de commits

On utilise les [Conventional Commits](https://www.conventionalcommits.org/) :

- `feat:` nouvelle fonctionnalité
- `fix:` correction de bug
- `docs:` documentation
- `refactor:` refactorisation sans changement de comportement
- `ci:` intégration continue / packaging

## Publier une nouvelle version

1. Mettre à jour le changelog :
   ```bash
   cd packaging
   dch -v 1.8-1 "Description de la nouveauté"
   ```
   > La version affichée par `lnmp -v` est **injectée automatiquement** depuis
   > le changelog au moment du build (voir `packaging/debian/rules`). Ne codez plus
   > jamais la version en dur dans `bin/lnmp`.
2. Committer et créer un tag :
   ```bash
   git commit -am "feat: ..."
   git tag v1.8-1
   git push --tags
   ```
3. La CI construit le `.deb`. Pour un build/déploiement manuel :
   ```bash
   ./build.sh 1.8-1 "Description de la nouveauté"
   ```

## Style de code (Bash)

- `shellcheck` doit passer sans avertissement.
- Toujours quoter les variables : `"$var"`.
- Valider les entrées utilisateur avant de les écrire dans une config Nginx.
