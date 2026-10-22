# Analytics PostHog (NAN-117)

Plan de tracking de Nanimo et import des dashboards de suivi.

## Importer les dashboards

1. Dans PostHog, créer une clé personnelle : *Settings > Personal API keys*, scopes `dashboard:write` et `insight:write`.
2. Récupérer l'id du projet : *Settings > Project > Project ID*.
3. Lancer :

```bash
POSTHOG_PERSONAL_API_KEY=phx_xxx python3 docs/analytics/import_posthog_dashboards.py --project <id>
```

`--host` vaut `https://eu.posthog.com` par défaut (`https://us.posthog.com` pour un projet US), `--dry-run` liste ce qui serait créé. Un dashboard dont le nom existe déjà est ignoré : le script peut être relancé.

Six dashboards sont créés, tagués `nanimo` : Acquisition & onboarding, Activation, Engagement & rétention, Santé, Notifications, Monétisation. Leur définition est dans [`posthog_dashboards.json`](posthog_dashboards.json).

## À activer côté consoles

- **RevenueCat > Integrations > PostHog** : clé du projet PostHog. L'app pose l'attribut `$posthogUserId` (= id Supabase) à chaque connexion, les événements `rc_*` atterrissent donc sur la même personne que les événements de l'app. Sans cette intégration, le dashboard Monétisation n'a que la partie in-app.
- **PostHog > Settings > Session replay** : activer « Record user sessions » pour mobile. Le SDK masque déjà tous les textes et images.
- **App Store Connect** (privacy label) et **Play Console** (Data safety) : déclarer « Product interaction », lié à l'identifiant utilisateur, non utilisé pour le suivi publicitaire.

## Règles

- Les noms d'événements ne changent jamais une fois livrés : un renommage coupe les funnels en deux.
- Jamais de texte libre (titre, description, prénom, email) : uniquement des codes et des compteurs.
- L'utilisateur peut couper les statistiques dans *Paramètres > Confidentialité* ; l'opt-out est persisté par le SDK.

## Événements

| Domaine | Événement | Propriétés |
| --- | --- | --- |
| Auth | `account_created`, `auth_completed` | `method` |
| Auth | `auth_failed` | `method`, `reason` (`cancelled`, `network`, `server`, code Supabase) |
| Auth | `signed_out`, `account_deleted` | |
| Onboarding | `onboarding_started`, `onboarding_slide_viewed`, `onboarding_step_completed` | `step` |
| Animal | `pet_created` | `source` (`onboarding`, `add_pet`), `species` |
| Animal | `pet_creation_failed` | `reason` |
| Animal | `pet_deleted` | |
| Souvenir | `memory_created`, `first_memory_created` | `event_type`, `photo_count`, `pet_count`, `has_description` |
| Souvenir | `memory_edited` | `photo_count` (ajoutées), `pet_count`, `has_description` |
| Souvenir | `memory_deleted` | |
| Journal | `journal_view_switched` | `view_mode` |
| Journal | `journal_filter_applied` | `filter` (`pet`, `type`) |
| Accueil | `home_card_tapped` | `card` |
| Accueil | `article_opened` | `item` |
| Santé | `vaccine_created`, `vet_visit_created` | `source`, `upcoming` |
| Santé | `weight_logged` | `source` (`create_menu`, `pet_page`) |
| Notifications | `notification_permission` | `result` |
| Notifications | `reminder_scheduled`, `notification_opened` | `kind` |
| Notifications | `notification_preference_changed` | `category`, `enabled` |
| Monétisation | `paywall_opened`, `paywall_dismissed`, `paywall_offer_selected`, `purchase_*`, `restore_*` | `trigger`, `plan`, `reason` |
| Confidentialité | `analytics_opted_out` | |

`first_memory_created` part en même temps que le premier `memory_created` d'un compte (cache local vide avant la création).

## Propriétés de profil

`pet_count`, `species` (codes séparés par des virgules), `memory_count` (tranches `0`, `1`, `2-4`, `5-9`, `10-24`, `25+`), `has_vaccine`, `is_premium`, `plan`, `auth_method`, `notifications_enabled` (interrupteur in-app), `notification_permission` (autorisation système).
