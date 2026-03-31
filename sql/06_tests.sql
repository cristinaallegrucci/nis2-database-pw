
-- VERIFICA STRUTTURA DATABASE


-- Elenco tabelle presenti
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Conteggio record nelle tabelle principali
SELECT 'Servizio' AS tabella, COUNT(*) FROM Servizio
UNION ALL
SELECT 'Asset', COUNT(*) FROM Asset
UNION ALL
SELECT 'Fornitore', COUNT(*) FROM Fornitore
UNION ALL
SELECT 'Responsabile', COUNT(*) FROM Responsabile
UNION ALL
SELECT 'Controllo_di_sicurezza', COUNT(*) FROM Controllo_di_sicurezza
UNION ALL
SELECT 'Processo', COUNT(*) FROM Processo
UNION ALL
SELECT 'Formazione', COUNT(*) FROM Formazione;


-- TEST VINCOLI (DEVONO FALLIRE)


-- FK: id_servizio inesistente
INSERT INTO Servizio_Asset (id_servizio, id_asset)
VALUES (999, 1);

-- CHECK: valore criticita non valido
INSERT INTO Servizio (nome, descrizione, criticita, stato)
VALUES ('Test Errato', 'Servizio di test', 'Critica', 'Attivo');


-- TEST JOIN E RELAZIONI


-- Verifica associazione Servizio-Asset
SELECT
    s.nome AS servizio,
    a.nome AS asset
FROM Servizio s
JOIN Servizio_Asset sa ON s.id_servizio = sa.id_servizio
JOIN Asset a ON sa.id_asset = a.id_asset
ORDER BY s.nome;


-- TEST VIEW ACN


-- Verifica contenuto vista
SELECT *
FROM v_export_acn
ORDER BY servizio;

-- Verifica colonne principali della vista
SELECT servizio, criticita_servizio, asset_critici
FROM v_export_acn;


-- TEST VERSIONING (TRIGGER)


-- Aggiornamento di test su Servizio
UPDATE Servizio
SET stato = 'Test Versioning'
WHERE id_servizio = 1;

-- Verifica storico modifiche
SELECT
    nome_tabella,
    operazione,
    record_id,
    data_operazione,
    dati_precedenti,
    dati_nuovi
FROM Audit_Log
ORDER BY data_operazione DESC;


-- TEST QUERY BASE


-- Servizi con criticita alta
SELECT nome, criticita
FROM Servizio
WHERE criticita = 'Alta';