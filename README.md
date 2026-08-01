# Studio Digital — DAVID REGNERY Immobilier

Application de gestion de contenu local : génération d'articles avec Claude, planification 2x/semaine, médiathèque photos, publication multi-supports (fiche Google Business, blog Webflow, Facebook, Instagram, LinkedIn) et audit de positions locales.

## Architecture

- **Frontend** : `public/index.html` (page unique, sans framework)
- **API** : `functions/api/[[route]].js` (Cloudflare Pages Functions)
- **Base de données** : Cloudflare D1 (`migrations/`)
- **Photos** : Cloudflare R2 (bucket `studio-digital-photos`)
- **Accès** : code d'accès unique (variable d'environnement `APP_SECRET`)

## Déploiement (Cloudflare Pages)

```bash
# 1. Créer la base D1 et reporter son id dans wrangler.toml
npx wrangler d1 create studio-digital

# 2. Appliquer les migrations
npx wrangler d1 migrations apply studio-digital --remote

# 3. Créer le bucket R2
npx wrangler r2 bucket create studio-digital-photos

# 4. Créer le projet Pages et déployer
npx wrangler pages project create studio-digital --production-branch main
npx wrangler pages deploy public --project-name studio-digital

# 5. Définir le code d'accès (dashboard Pages → Settings → Environment variables)
#    APP_SECRET = <code choisi>
```

Les bindings D1 (`DB`) et R2 (`PHOTOS`) sont lus depuis `wrangler.toml`.

## Circuit de publication

1. Claude génère un pack (post Google + article blog + FB/IG/LinkedIn) → statut `review`
2. David relit/modifie dans l'application → clique **Valider** → statut `approved`
3. Claude publie sur les canaux configurés → statut `published`

## API (résumé)

Toutes les routes sous `/api/`, authentifiées par `Authorization: Bearer <APP_SECRET>` (sauf `GET /api/photos/<key>`).

- `GET /api/state` — tout l'état (publications, photos, créneaux, réglages)
- `POST /api/publications` · `PUT/DELETE /api/publications/:id`
- `POST /api/photos` (corps binaire + `X-Photo-Name`) · `PUT/DELETE /api/photos/:key`
- `PUT /api/settings` — enregistre les réglages (canaux, fréquence, mots-clés)
- `POST /api/slots` · `DELETE /api/slots/:id`
- `GET/POST /api/audit` — relevés de positions locales
