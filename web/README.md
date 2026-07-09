# Site de documentation LNMP

Page de documentation **autonome** (HTML/CSS/JS inline, aucune dépendance
externe). Il suffit de déposer `index.html` sur un serveur web.

## Déploiement sur le serveur Mawena

```bash
# Copier la page sur le serveur (adapter le chemin de destination)
scp -P 2244 web/index.html mawena.cloud:/var/www/html/mawena.cloud/docs/index.html
```

Ou créer un vhost dédié avec LNMP lui-même :

```bash
sudo lnmp add          # id: lnmp-docs, domaine: docs.mawena.cloud, chemin: .../docs
sudo lnmp add-ssl lnmp-docs
```

## Aperçu local

```bash
python3 -m http.server 8000 --directory web
# puis ouvrir http://localhost:8000
```
