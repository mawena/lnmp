# FAQ & dépannage

## L'installation s'est interrompue, comment reprendre ?

Relancez simplement :

```bash
sudo lnmp install
```

L'installation reprend à la dernière étape réussie (état dans
`/var/log/lnmp_install_state`).

## `add-ssl` échoue (Certbot ne valide pas le domaine)

Vérifiez que :

1. le **domaine pointe** bien vers l'IP publique du serveur (`dig +short mondomaine`) ;
2. les **ports 80 et 443** sont ouverts sur le pare-feu ;
3. l'application est **active** (`sudo lnmp list`).

## Nginx ne redémarre pas après une modification

LNMP teste toujours la configuration (`nginx -t`) avant de recharger et **refuse
de recharger** une config invalide. Pour voir l'erreur exacte :

```bash
sudo nginx -t
```

## Où sont le nom d'utilisateur et le mot de passe de ma base ?

Ils sont affichés **une seule fois** à la création (`db-create`). Notez-les
immédiatement. En cas de perte, recréez un utilisateur via `mariadb`.

## J'ai édité un vhost à la main, le registre est désynchronisé

```bash
sudo lnmp reload-app
```

## Comment mettre à jour LNMP ?

Via le dépôt APT :

```bash
sudo apt update && sudo apt upgrade lnmp
```

## Comment changer la version de PHP ?

Modifiez la variable `PHP_VERSION` en tête de `/usr/bin/lnmp`, puis réinstallez
les paquets PHP correspondants. (Une prochaine version rendra ce réglage
interactif.)

## Puis-je tester sans risque ?

Oui — testez toujours dans une **VM ou un conteneur** Ubuntu. LNMP modifie Nginx,
MariaDB et les droits système ; **ne l'exécutez jamais pour la première fois sur
un serveur de production**.
