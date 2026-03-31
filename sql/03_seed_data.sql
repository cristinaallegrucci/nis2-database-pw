INSERT INTO Servizio (nome, descrizione, criticita, stato, esito_assessment) VALUES
('SOC', 'Security Operation Center per il monitoraggio degli eventi di sicurezza', 'Alta', 'Attivo', 'Conforme'),
('SIEM', 'Sistema di raccolta e correlazione dei log', 'Alta', 'Attivo', 'Parzialmente conforme'),
('Cloud Management', 'Gestione infrastruttura cloud', 'Media', 'Attivo', 'Conforme'),
('Backup & Recovery', 'Servizio di backup e ripristino dati', 'Alta', 'Attivo', 'Conforme');

INSERT INTO Asset (nome, categoria, tipo_asset, criticita, stato) VALUES
('Server SOC', 'Infrastruttura', 'Server', 'Alta', 'Operativo'),
('Piattaforma SIEM', 'Applicazione', 'Software', 'Alta', 'Operativo'),
('Storage Backup', 'Infrastruttura', 'Storage', 'Alta', 'Operativo'),
('VM Cloud', 'Infrastruttura', 'Virtual Machine', 'Media', 'Operativo');

INSERT INTO Fornitore (nome, tipo_fornitura, criticita_dipendenza, stato) VALUES
('CloudItalia', 'Servizi Cloud', 'Alta', 'Attivo'),
('SecureLogs', 'Piattaforma SIEM', 'Alta', 'Attivo'),
('BackupSafe', 'Servizi di Backup', 'Media', 'Attivo');

INSERT INTO Responsabile (ruolo, descrizione, area) VALUES
('CISO', 'Responsabile della sicurezza delle informazioni', 'Sicurezza'),
('Incident Manager', 'Gestione degli incidenti di sicurezza', 'Sicurezza'),
('IT Operations Manager', 'Gestione operativa infrastrutture IT', 'IT');

INSERT INTO Controllo_di_sicurezza (tipo_controllo, categoria_controllo, stato, esito_assessment) VALUES
('Logging centralizzato', 'Tecnico', 'Implementato', 'Conforme'),
('Cifratura dati', 'Tecnico', 'Implementato', 'Conforme'),
('Backup periodico', 'Tecnico', 'Implementato', 'Conforme'),
('Policy di sicurezza', 'Organizzativo', 'Implementato', 'Parzialmente conforme');

INSERT INTO Processo (nome, descrizione, stato, esito_assessment) VALUES
('Incident Response', 'Gestione degli incidenti di sicurezza informatica', 'Attivo', 'Conforme'),
('Business Continuity', 'Continuita operativa dei servizi critici', 'Attivo', 'Parzialmente conforme');

INSERT INTO Formazione (tipo_formazione, ambito, periodicita, stato) VALUES
('Cybersecurity Awareness', 'Cybersecurity', 'Annuale', 'Attiva'),
('Incident Response Training', 'Cybersecurity', 'Biennale', 'Attiva');

INSERT INTO Servizio_Asset (id_servizio, id_asset) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 4),
(4, 3);

INSERT INTO Servizio_Fornitore (id_servizio, id_fornitore) VALUES
(3, 1),
(2, 2),
(4, 3);

INSERT INTO Servizio_Responsabile (id_servizio, id_responsabile) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 3),
(4, 3);

INSERT INTO Servizio_Controllo (id_servizio, id_controllo) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 4),
(4, 3);

INSERT INTO Processo_Servizio (id_processo, id_servizio) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4);

INSERT INTO Formazione_Responsabile (id_formazione, id_responsabile) VALUES
(1, 1),
(1, 3),
(2, 2);
