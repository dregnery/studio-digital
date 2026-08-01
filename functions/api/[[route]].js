// Studio Digital — API (Cloudflare Pages Functions)
// Bindings requis : DB (D1), PHOTOS (R2) — Variable : APP_SECRET

const JSON_HEADERS = {
  'Content-Type': 'application/json; charset=utf-8',
  'Access-Control-Allow-Origin': '*'
};

function ok(data, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: JSON_HEADERS });
}
function err(message, status = 400) {
  return ok({ error: message }, status);
}

function authorized(request, env) {
  const h = request.headers.get('Authorization') || '';
  const key = h.replace(/^Bearer\s+/i, '');
  return env.APP_SECRET && key === env.APP_SECRET;
}

export async function onRequest(context) {
  const { request, env, params } = context;
  const route = (params.route || []).join('/');
  const method = request.method;

  // CORS (l'app est servie sur le même domaine ; utile pour les accès de Claude)
  if (method === 'OPTIONS') {
    return new Response(null, { headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
      'Access-Control-Allow-Headers': 'Authorization,Content-Type,X-Photo-Name,X-Photo-Label'
    }});
  }

  // Photo publique (affichage dans l'app) : GET /api/photos/<key>
  if (route.startsWith('photos/') && method === 'GET') {
    const key = decodeURIComponent(route.slice('photos/'.length));
    const obj = await env.PHOTOS.get(key);
    if (!obj) return err('Photo introuvable', 404);
    return new Response(obj.body, { headers: {
      'Content-Type': obj.httpMetadata?.contentType || 'image/jpeg',
      'Cache-Control': 'public, max-age=31536000',
      'Access-Control-Allow-Origin': '*'
    }});
  }

  // Tout le reste est protégé
  if (!authorized(request, env)) return err('Accès refusé — code invalide', 401);

  // ------- ÉTAT GLOBAL -------
  if (route === 'state' && method === 'GET') {
    const [pubs, photos, slots, settings] = await Promise.all([
      env.DB.prepare('SELECT * FROM publications ORDER BY COALESCE(planned_at, published_at) DESC').all(),
      env.DB.prepare('SELECT * FROM photos ORDER BY uploaded_at DESC').all(),
      env.DB.prepare("SELECT * FROM slots WHERE date >= date('now','-1 day') ORDER BY date").all(),
      env.DB.prepare('SELECT * FROM settings').all()
    ]);
    const settingsMap = {};
    for (const s of settings.results) settingsMap[s.key] = s.value;
    return ok({
      publications: pubs.results.map(p => ({ ...p, channels: JSON.parse(p.channels), contents: JSON.parse(p.contents) })),
      photos: photos.results,
      slots: slots.results,
      settings: settingsMap
    });
  }

  // ------- PUBLICATIONS -------
  if (route === 'publications' && method === 'POST') {
    const b = await request.json();
    const id = b.id || crypto.randomUUID();
    await env.DB.prepare(
      `INSERT INTO publications (id,title,planned_at,published_at,status,excerpt,photo_key,channels,contents,source)
       VALUES (?,?,?,?,?,?,?,?,?,?)`
    ).bind(id, b.title, b.planned_at || null, b.published_at || null, b.status || 'draft',
           b.excerpt || '', b.photo_key || null, JSON.stringify(b.channels || []),
           JSON.stringify(b.contents || {}), b.source || 'claude').run();
    return ok({ id });
  }

  const pubMatch = route.match(/^publications\/([\w-]+)$/);
  if (pubMatch && (method === 'PUT' || method === 'DELETE')) {
    const id = pubMatch[1];
    if (method === 'DELETE') {
      await env.DB.prepare('DELETE FROM publications WHERE id=?').bind(id).run();
      return ok({ deleted: id });
    }
    const b = await request.json();
    const fields = [];
    const vals = [];
    for (const [col, val] of Object.entries({
      title: b.title, planned_at: b.planned_at, published_at: b.published_at,
      status: b.status, excerpt: b.excerpt, photo_key: b.photo_key,
      channels: b.channels ? JSON.stringify(b.channels) : undefined,
      contents: b.contents ? JSON.stringify(b.contents) : undefined
    })) {
      if (val !== undefined) { fields.push(`${col}=?`); vals.push(val); }
    }
    if (!fields.length) return err('Rien à modifier');
    vals.push(id);
    await env.DB.prepare(`UPDATE publications SET ${fields.join(',')}, updated_at=datetime('now') WHERE id=?`).bind(...vals).run();
    return ok({ updated: id });
  }

  // ------- PHOTOS : import depuis une URL (le serveur va chercher l'image, pas de CORS) -------
  if (route === 'photos-import' && method === 'POST') {
    const b = await request.json();
    if (!b.url) return err('url manquante');
    const imgRes = await fetch(b.url, { headers: { 'User-Agent': 'Mozilla/5.0 (StudioDigital)' } });
    if (!imgRes.ok) return err('Image inaccessible (' + imgRes.status + ')', 502);
    const contentType = imgRes.headers.get('content-type') || 'image/jpeg';
    if (!contentType.startsWith('image/')) return err('Ce n\'est pas une image (' + contentType + ')');
    const body = await imgRes.arrayBuffer();
    if (body.byteLength > 15 * 1024 * 1024) return err('Image trop lourde');
    const name = (b.name || b.url.split('/').pop().split('?')[0] || 'photo.jpg').slice(0, 80);
    const key = `${Date.now()}-${name.replace(/[^\w.\-]+/g, '_')}`;
    await env.PHOTOS.put(key, body, { httpMetadata: { contentType } });
    await env.DB.prepare('INSERT INTO photos (key,name,content_type,size,label) VALUES (?,?,?,?,?)')
      .bind(key, name, contentType, body.byteLength, b.label || '').run();
    return ok({ key, size: body.byteLength });
  }

  // ------- PHOTOS -------
  if (route === 'photos' && method === 'POST') {
    // Corps binaire + en-têtes X-Photo-Name / X-Photo-Label
    const name = decodeURIComponent(request.headers.get('X-Photo-Name') || 'photo.jpg');
    const label = decodeURIComponent(request.headers.get('X-Photo-Label') || '');
    const contentType = request.headers.get('Content-Type') || 'image/jpeg';
    const key = `${Date.now()}-${name.replace(/[^\w.\-]+/g, '_')}`;
    const body = await request.arrayBuffer();
    if (body.byteLength > 15 * 1024 * 1024) return err('Photo trop lourde (max 15 Mo)');
    await env.PHOTOS.put(key, body, { httpMetadata: { contentType } });
    await env.DB.prepare('INSERT INTO photos (key,name,content_type,size,label) VALUES (?,?,?,?,?)')
      .bind(key, name, contentType, body.byteLength, label).run();
    return ok({ key });
  }

  const photoMatch = route.match(/^photos\/(.+)$/);
  if (photoMatch && method === 'DELETE') {
    const key = decodeURIComponent(photoMatch[1]);
    await env.PHOTOS.delete(key);
    await env.DB.prepare('DELETE FROM photos WHERE key=?').bind(key).run();
    return ok({ deleted: key });
  }
  if (photoMatch && method === 'PUT') {
    const key = decodeURIComponent(photoMatch[1]);
    const b = await request.json();
    await env.DB.prepare('UPDATE photos SET label=?, last_used_at=COALESCE(?,last_used_at) WHERE key=?')
      .bind(b.label || '', b.last_used_at || null, key).run();
    return ok({ updated: key });
  }

  // ------- PONT WEBFLOW (le jeton reste côté serveur : secret WEBFLOW_TOKEN) -------
  if (route.startsWith('webflow/')) {
    if (!env.WEBFLOW_TOKEN) return err('WEBFLOW_TOKEN non configuré', 500);
    const wfPath = route.slice('webflow/'.length);
    const init = {
      method,
      headers: {
        'Authorization': 'Bearer ' + env.WEBFLOW_TOKEN,
        'accept': 'application/json',
        'content-type': 'application/json'
      }
    };
    if (method === 'POST' || method === 'PATCH' || method === 'PUT') {
      init.body = await request.text();
    }
    const wfRes = await fetch('https://api.webflow.com/v2/' + wfPath, init);
    return new Response(await wfRes.text(), { status: wfRes.status, headers: JSON_HEADERS });
  }

  // ------- RÉGLAGES -------
  if (route === 'settings' && method === 'PUT') {
    const b = await request.json();
    const stmts = Object.entries(b).map(([k, v]) =>
      env.DB.prepare('INSERT INTO settings (key,value) VALUES (?,?) ON CONFLICT(key) DO UPDATE SET value=excluded.value').bind(k, String(v ?? ''))
    );
    await env.DB.batch(stmts);
    return ok({ saved: Object.keys(b) });
  }

  // ------- PLANIFICATEUR -------
  if (route === 'slots' && method === 'POST') {
    const b = await request.json();
    const id = b.id || crypto.randomUUID();
    await env.DB.prepare('INSERT OR REPLACE INTO slots (id,date,time,theme,title,note,publication_id) VALUES (?,?,?,?,?,?,?)')
      .bind(id, b.date, b.time || '10:30', b.theme || '', b.title || '', b.note || '', b.publication_id || null).run();
    return ok({ id });
  }
  const slotMatch = route.match(/^slots\/([\w-]+)$/);
  if (slotMatch && method === 'DELETE') {
    await env.DB.prepare('DELETE FROM slots WHERE id=?').bind(slotMatch[1]).run();
    return ok({ deleted: slotMatch[1] });
  }

  // ------- AUDIT -------
  if (route === 'audit' && method === 'GET') {
    const snaps = await env.DB.prepare('SELECT * FROM audit_snapshots ORDER BY taken_at DESC LIMIT 50').all();
    return ok({ snapshots: snaps.results.map(s => ({ ...s, grid: JSON.parse(s.grid), stats: s.stats ? JSON.parse(s.stats) : null })) });
  }
  if (route === 'audit' && method === 'POST') {
    const b = await request.json();
    const id = b.id || crypto.randomUUID();
    await env.DB.prepare('INSERT INTO audit_snapshots (id,taken_at,keyword,grid,stats) VALUES (?,?,?,?,?)')
      .bind(id, b.taken_at || new Date().toISOString(), b.keyword, JSON.stringify(b.grid || []), JSON.stringify(b.stats || null)).run();
    return ok({ id });
  }

  return err('Route inconnue : ' + method + ' /' + route, 404);
}
