-- Studio Digital — schéma initial
CREATE TABLE IF NOT EXISTS publications (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  planned_at TEXT,            -- ISO date/heure de publication prévue
  published_at TEXT,          -- ISO date/heure de publication effective
  status TEXT NOT NULL DEFAULT 'draft',  -- draft | review | approved | published
  excerpt TEXT,
  photo_key TEXT,             -- clé R2 de la photo choisie
  channels TEXT NOT NULL DEFAULT '[]',   -- JSON: ["g","web","fb","ig","in"]
  contents TEXT NOT NULL DEFAULT '{}',   -- JSON: {g:"...", web:"...", fb:"...", ig:"...", in:"..."}
  source TEXT DEFAULT 'claude',          -- claude | mapduo | manuel
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS photos (
  key TEXT PRIMARY KEY,       -- clé R2
  name TEXT NOT NULL,
  content_type TEXT,
  size INTEGER,
  label TEXT,                 -- description libre (ex: "terrasse Voreppe")
  last_used_at TEXT,
  uploaded_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS slots (
  id TEXT PRIMARY KEY,
  date TEXT NOT NULL,         -- ISO date
  time TEXT NOT NULL DEFAULT '10:30',
  theme TEXT,
  title TEXT,
  note TEXT,
  publication_id TEXT
);

CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT
);

CREATE TABLE IF NOT EXISTS audit_snapshots (
  id TEXT PRIMARY KEY,
  taken_at TEXT NOT NULL,
  keyword TEXT NOT NULL,
  grid TEXT NOT NULL,         -- JSON: [{lat,lng,pos}...]
  stats TEXT                  -- JSON: {views, searches, reviews, rating...}
);

-- Réglages par défaut
INSERT OR IGNORE INTO settings (key, value) VALUES
 ('frequency', '2/semaine (lundi & jeudi 10h30)'),
 ('channel_g', 'DAVID REGNERY Immobilier — Saint-Égrève'),
 ('channel_web', 'https://davidregneryimmobilier.com/actualites'),
 ('channel_fb', ''),
 ('channel_ig', ''),
 ('channel_in', ''),
 ('keywords', 'agence immobilière saint-égrève|agence immobilière st égrève|agence immo saint-égrève|agent immobilier saint-égrève|agent immo saint égrève');
