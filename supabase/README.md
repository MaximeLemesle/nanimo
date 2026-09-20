# Supabase — le schéma de Nanimo

Un seul fichier décrit la base : `migrations/0001_baseline.sql`. Il est généré
depuis la base live, jamais écrit à la main.

## La règle

**La base live est la source de vérité.** Ce dossier la décrit, il ne la pilote
pas.

Un changement de schéma se fait à la main dans le SQL editor Supabase, puis on
régénère la baseline pour que le dépôt reflète le nouvel état.

🔴 **Ne jamais lancer `supabase db push`.** La base n'a aucun historique de
migrations enregistré : la colonne `Remote` de `supabase migration list` est
vide. Un push rejouerait la baseline depuis zéro sur une base déjà peuplée.

## Régénérer la baseline

Docker Desktop doit tourner, le dump s'exécute dans un conteneur.

```bash
supabase link --project-ref <ref>     # une seule fois par clone
supabase db dump --linked -f /tmp/nanimo_schema.sql
```

Puis remplacer le corps de `migrations/0001_baseline.sql` par ce fichier, en
gardant l'en-tête de provenance et en mettant sa date à jour.

Avant de commiter, vérifier que le dump ne contient **aucune donnée** :

```bash
grep -c "^INSERT INTO" /tmp/nanimo_schema.sql   # doit rendre 0
```

Le dump ne couvre que le schéma `public`. Les objets des schémas `auth`,
`storage` et `realtime` n'y sont pas, `handle_new_user` par exemple. Ce n'est
pas une omission, c'est le périmètre.

## Ce que le dépôt ne suit plus

`supabase/.temp/` est l'état local du CLI, dont la référence du projet lié.
`supabase/backups/` contenait deux dumps faits à la main, périmés. Les deux sont
dans le `.gitignore` depuis NAN-075. Un nouveau clone devra refaire
`supabase link`.

## Historique

Jusqu'au 20/09/2026, ce dossier portait neuf migrations `0001` à `0009` qui
avaient divergé de la base **dans les deux sens** : elles décrivaient des objets
absents et en ignoraient de présents. NAN-075 les a remplacées par la baseline.
L'historique git les conserve, le dernier commit avant remplacement fait foi.

Deux écarts trouvés à cette occasion ont été corrigés dans la base le même jour,
avant le dump : la fonction `delete_account`, que l'application appelle depuis
les Paramètres, n'existait pas, et les deux triggers de quota freemium
n'étaient pas posés.

## Les fonctions Edge

`functions/revenuecat-webhook/` n'est pas concerné par ce qui précède. Il se
déploie avec `supabase functions deploy`.
