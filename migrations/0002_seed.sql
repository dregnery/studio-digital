-- Données initiales : historique MapDuo + pack témoin + créneaux d'août 2026
INSERT OR IGNORE INTO publications (id,title,planned_at,status,excerpt,channels,contents,source) VALUES
('pack-2026-08-03','Prix au m² à Saint-Égrève — Été 2026','2026-08-03T10:30:00+02:00','review',
 'L''été 2026 offre une photographie intéressante du marché immobilier à Saint-Égrève et ses environs. Avec un prix moyen autour de 2 925 € le mètre carré...',
 '["g","web","fb","ig","in"]',
 json_object(
  'g','L''été 2026 offre une photographie intéressante du marché immobilier à Saint-Égrève et ses environs. Avec un prix moyen autour de 2 925 € le mètre carré — environ 2 460 € pour un appartement et 3 390 € pour une maison — notre commune reste l''une des plus recherchées de la rive gauche du Grésivaudan, entre Vercors et Chartreuse. Les prix se sont légèrement assouplis ces douze derniers mois, ce qui crée de réelles opportunités pour les acheteurs, tandis que les biens bien estimés et bien présentés continuent de se vendre dans de bons délais. Depuis plus de dix ans, notre agence accompagne les vendeurs et les acquéreurs de Saint-Égrève, Le Fontanil-Cornillon, Voreppe et Sassenage avec une connaissance fine de chaque quartier, de Rochepleine à La Monta. Vous vous interrogez sur la valeur de votre bien dans ce marché en mouvement ? Nous réalisons votre estimation précise et sans engagement, et nous vous conseillons sur la meilleure stratégie pour votre projet. Contactez-nous pour en parler.',
  'web','TITRE : Les prix au m² à Saint-Égrève (Été 2026) : le point complet' || char(10) || 'SOUS-TITRE : Appartements, maisons, tendances par quartier : ce que disent les chiffres de l''été 2026.' || char(10) || 'PLAN : 1. Les chiffres clés · 2. Quartier par quartier · 3. Vendeurs : l''estimation juste · 4. Acheteurs : une fenêtre d''opportunité · 5. Notre lecture pour la rentrée 2026' || char(10) || '(Article complet rédigé à la validation.)',
  'fb','📊 Où en sont les prix immobiliers à Saint-Égrève cet été ?' || char(10) || char(10) || 'En moyenne 2 925 € le m² : environ 2 460 € pour un appartement, 3 390 € pour une maison. Après plusieurs années de hausse, les prix se sont légèrement détendus (−2 à −3 % sur un an). 🏡' || char(10) || char(10) || 'Concrètement ? Les acheteurs retrouvent des marges de négociation... et les vendeurs qui estiment juste vendent toujours bien, souvent avant la rentrée.' || char(10) || char(10) || 'Estimation offerte, sans engagement. 👇' || char(10) || '📞 06 67 93 45 66' || char(10) || char(10) || '#SaintEgreve #Immobilier #Grenoble #EstimationGratuite #Vercors',
  'ig','Le marché immobilier de Saint-Égrève à l''été 2026, en 3 chiffres 👇' || char(10) || char(10) || '🏢 Appartements : ~2 460 €/m²' || char(10) || '🏡 Maisons : ~3 390 €/m²' || char(10) || '📉 Tendance sur 1 an : −2 à −3 %' || char(10) || char(10) || 'Traduction : le marché se rééquilibre. Les biens bien estimés et bien mis en valeur partent toujours vite — les autres attendent.' || char(10) || char(10) || 'Écrivez-nous en DM ou appelez le 06 67 93 45 66. Estimation offerte 🤝' || char(10) || char(10) || '#immobilier #saintegreve #grenoble #isere #vendremaison #estimationimmobiliere #agentimmobilier #chartreuse #vercors #achatimmobilier #investissementimmobilier #immo38',
  'in','Été 2026 : le marché immobilier de Saint-Égrève entre dans une phase de rééquilibrage.' || char(10) || char(10) || 'Les chiffres de juillet : un prix moyen autour de 2 925 €/m², avec environ 2 460 €/m² pour les appartements et 3 390 €/m² pour les maisons, soit un repli mesuré de 2 à 3 % sur douze mois.' || char(10) || char(10) || 'Ce que j''observe sur le terrain, après plus de dix ans et 225 ventes sur le secteur : ce n''est pas un marché qui baisse, c''est un marché qui trie. Les biens estimés au juste prix trouvent preneur dans de bons délais. Les biens surévalués s''installent dans la durée.' || char(10) || char(10) || 'Pour les vendeurs, l''enjeu de la rentrée sera la justesse de l''estimation initiale. Pour les acquéreurs, la fenêtre actuelle offre des conditions de négociation inédites depuis plusieurs années sur la rive gauche du Grésivaudan.' || char(10) || char(10) || 'David REGNERY — DAVID REGNERY Immobilier, Saint-Égrève' || char(10) || '#immobilier #grenoble #marchéimmobilier #saintegreve'
 ),'claude');

INSERT OR IGNORE INTO publications (id,title,published_at,status,excerpt,channels,contents,source) VALUES
('mapduo-2026-07-17','Publication du 17/07/2026','2026-07-17T10:30:00+02:00','published',
 'L''accompagnement dans votre projet immobilier à Voreppe mérite une attention particulière et un savoir-faire éprouvé...',
 '["g"]', json_object('g','L''accompagnement dans votre projet immobilier à Voreppe mérite une attention particulière et un savoir-faire éprouvé. Depuis plusieurs années, notre agence immobilière Saint-Égrève met son expérience au service des vendeurs et des acquéreurs pour concrétiser leurs ambitions résidentielles. Que vous cherchiez à vendre votre bien, à acquérir une maison ou un appartement, notre connaissance approfondie du marché local constitue un atout majeur. Nous accompagnons chaque client avec méthode et rigueur, de l''estimation jusqu''à la signature chez le notaire. Contactez-nous pour bénéficier d''un accompagnement professionnel et d''un conseil de qualité dans vos démarches immobilières.'),'mapduo'),
('mapduo-2026-07-13','Publication du 13/07/2026','2026-07-13T10:30:00+02:00','published',
 'L''été approche et avec lui, la période idéale pour concrétiser vos projets immobiliers à Saint-Égrève et ses environs...',
 '["g"]', json_object('g','(Texte historique MapDuo)'),'mapduo'),
('mapduo-2026-07-06','Publication du 06/07/2026','2026-07-06T10:30:00+02:00','published',
 'Vendre ou acheter un bien immobilier représente souvent l''une des décisions les plus importantes de votre vie...',
 '["g"]', json_object('g','(Texte historique MapDuo)'),'mapduo'),
('mapduo-2026-07-03','Publication du 03/07/2026','2026-07-03T10:30:00+02:00','published',
 'Vous envisagez de vendre votre bien immobilier à Sassenage ou dans les environs...',
 '["g"]', json_object('g','(Texte historique MapDuo)'),'mapduo'),
('mapduo-2026-06-29','Publication du 29/06/2026','2026-06-29T10:30:00+02:00','published',
 'Le marché immobilier de Predieu connaît une dynamique particulière en ce début d''été...',
 '["g"]', json_object('g','(Texte historique MapDuo)'),'mapduo'),
('mapduo-2026-06-24','Publication du 24/06/2026','2026-06-24T10:00:00+02:00','published',
 'L''été arrive avec son lot d''opportunités pour concrétiser vos projets immobiliers à Saint-Égrève...',
 '["g"]', json_object('g','(Texte historique MapDuo)'),'mapduo');

INSERT OR IGNORE INTO slots (id,date,time,theme,title,note,publication_id) VALUES
('s-2026-08-03','2026-08-03','10:30','Prix & marché','Prix au m² à Saint-Égrève — Été 2026','Pack prêt — en attente de validation','pack-2026-08-03'),
('s-2026-08-06','2026-08-06','10:30','Focus quartier','[Focus Quartier] La Monta : le village dans la ville','Reprend la série du blog arrêtée en avril',NULL),
('s-2026-08-10','2026-08-10','10:30','Conseils vendeurs','Préparer la vente de son bien pour la rentrée : la check-list',NULL,NULL),
('s-2026-08-13','2026-08-13','10:30','Focus commune','Voreppe : un marché porté par les familles',NULL,NULL),
('s-2026-08-17','2026-08-17','10:30','Conseils acheteurs','Taux de crédit : où en est-on à la rentrée 2026 ?',NULL,NULL),
('s-2026-08-20','2026-08-20','10:30','Focus commune','Sassenage : entre Vercors et agglomération',NULL,NULL),
('s-2026-08-24','2026-08-24','10:30','Conseils vendeurs','L''estimation juste : pourquoi elle fait toute la différence',NULL,NULL),
('s-2026-08-27','2026-08-27','10:30','Saisonnalité','Marché de la rentrée : ce qui attend vendeurs et acheteurs',NULL,NULL),
('s-2026-08-31','2026-08-31','10:30','Focus commune','Le Fontanil-Cornillon : la douceur résidentielle',NULL,NULL);
