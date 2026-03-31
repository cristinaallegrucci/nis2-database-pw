-- Q1: Elenco servizi erogati
SELECT
    id_servizio,
    nome,
    descrizione,
    criticita,
    stato,
    esito_assessment
FROM Servizio
ORDER BY criticita DESC, nome;

-- Q2: Asset critici associati ai servizi
SELECT
    a.id_asset,
    a.nome AS asset,
    a.categoria,
    a.tipo_asset,
    a.criticita,
    s.nome AS servizio
FROM Asset a
JOIN Servizio_Asset sa ON a.id_asset = sa.id_asset
JOIN Servizio s ON sa.id_servizio = s.id_servizio
WHERE a.criticita = 'Alta'
ORDER BY s.nome;

-- Q3: Dipendenze da fornitori per servizio
SELECT
    s.nome AS servizio,
    f.nome AS fornitore,
    f.tipo_fornitura,
    f.criticita_dipendenza,
    f.stato
FROM Servizio s
JOIN Servizio_Fornitore sf ON s.id_servizio = sf.id_servizio
JOIN Fornitore f ON sf.id_fornitore = f.id_fornitore
ORDER BY s.nome;

-- Q4: Responsabili associati ai servizi
SELECT
    s.nome AS servizio,
    r.ruolo,
    r.area
FROM Servizio s
JOIN Servizio_Responsabile sr ON s.id_servizio = sr.id_servizio
JOIN Responsabile r ON sr.id_responsabile = r.id_responsabile
ORDER BY s.nome;

-- Q5: Controlli di sicurezza applicati ai servizi
SELECT
    s.nome AS servizio,
    c.tipo_controllo,
    c.categoria_controllo,
    c.stato,
    c.esito_assessment
FROM Servizio s
JOIN Servizio_Controllo sc ON s.id_servizio = sc.id_servizio
JOIN Controllo_di_sicurezza c ON sc.id_controllo = c.id_controllo
ORDER BY s.nome;

-- Q6: Processi di sicurezza applicati ai servizi
SELECT
    s.nome AS servizio,
    p.nome AS processo,
    p.stato,
    p.esito_assessment
FROM Servizio s
JOIN Processo_Servizio ps ON s.id_servizio = ps.id_servizio
JOIN Processo p ON ps.id_processo = p.id_processo
ORDER BY s.nome;

-- Q7: Vista riepilogativa per servizio (una riga per servizio)
SELECT
    s.nome AS servizio,
    s.criticita AS criticita_servizio,
    STRING_AGG(DISTINCT a.nome, ', ') FILTER (WHERE a.criticita = 'Alta') AS asset_critici,
    STRING_AGG(DISTINCT f.nome, ', ') AS fornitori,
    STRING_AGG(DISTINCT r.ruolo, ', ') AS punti_di_contatto
FROM Servizio s
LEFT JOIN Servizio_Asset sa ON s.id_servizio = sa.id_servizio
LEFT JOIN Asset a ON sa.id_asset = a.id_asset
LEFT JOIN Servizio_Fornitore sf ON s.id_servizio = sf.id_servizio
LEFT JOIN Fornitore f ON sf.id_fornitore = f.id_fornitore
LEFT JOIN Servizio_Responsabile sr ON s.id_servizio = sr.id_servizio
LEFT JOIN Responsabile r ON sr.id_responsabile = r.id_responsabile
GROUP BY s.nome, s.criticita
ORDER BY s.nome;

-- Q8: Servizi ad alta criticita
SELECT
    s.nome,
    s.criticita,
    s.stato,
    r.ruolo
FROM Servizio s
LEFT JOIN Servizio_Responsabile sr ON s.id_servizio = sr.id_servizio
LEFT JOIN Responsabile r ON sr.id_responsabile = r.id_responsabile
WHERE s.criticita = 'Alta'
ORDER BY s.nome;

-- Q9: Asset critici associati a servizi privi di controlli di sicurezza
SELECT
    a.nome,
    a.categoria,
    a.criticita
FROM Asset a
LEFT JOIN Servizio_Asset sa ON a.id_asset = sa.id_asset
LEFT JOIN Servizio s ON sa.id_servizio = s.id_servizio
LEFT JOIN Servizio_Controllo sc ON s.id_servizio = sc.id_servizio
WHERE a.criticita = 'Alta'
  AND sc.id_controllo IS NULL;

-- Q10: Fornitori con alta criticita di dipendenza
SELECT
    nome,
    tipo_fornitura,
    criticita_dipendenza
FROM Fornitore
WHERE criticita_dipendenza = 'Alta';

-- Q11: Servizi coperti dal processo di Incident Response
SELECT
    s.nome AS servizio,
    p.nome AS processo,
    p.stato
FROM Servizio s
JOIN Processo_Servizio ps ON s.id_servizio = ps.id_servizio
JOIN Processo p ON ps.id_processo = p.id_processo
WHERE p.nome = 'Incident Response';

-- Q12: Responsabili senza formazione associata
SELECT DISTINCT
    r.ruolo,
    r.area
FROM Responsabile r
LEFT JOIN Formazione_Responsabile fr ON r.id_responsabile = fr.id_responsabile
WHERE fr.id_formazione IS NULL;

-- Q13: Numero di asset per ciascun servizio
SELECT
    s.nome AS servizio,
    COUNT(sa.id_asset) AS numero_asset
FROM Servizio s
LEFT JOIN Servizio_Asset sa ON s.id_servizio = sa.id_servizio
GROUP BY s.nome
ORDER BY numero_asset DESC;

-- Q14: Numero di fornitori per servizio
SELECT
    s.nome AS servizio,
    COUNT(sf.id_fornitore) AS numero_fornitori
FROM Servizio s
LEFT JOIN Servizio_Fornitore sf ON s.id_servizio = sf.id_servizio
GROUP BY s.nome
ORDER BY numero_fornitori DESC;

-- Q15: Distribuzione dei servizi per livello di criticita
SELECT
    criticita,
    COUNT(*) AS numero_servizi
FROM Servizio
GROUP BY criticita;

-- Q16: Servizi senza controlli di sicurezza associati
SELECT
    s.nome AS servizio
FROM Servizio s
LEFT JOIN Servizio_Controllo sc ON s.id_servizio = sc.id_servizio
WHERE sc.id_controllo IS NULL;

-- Q17: Responsabili coinvolti in più servizi
SELECT
    r.ruolo,
    COUNT(sr.id_servizio) AS numero_servizi
FROM Responsabile r
JOIN Servizio_Responsabile sr ON r.id_responsabile = sr.id_responsabile
GROUP BY r.ruolo
HAVING COUNT(sr.id_servizio) > 1
ORDER BY numero_servizi DESC;

-- Q18: Controlli di sicurezza applicati a più servizi
SELECT
    c.tipo_controllo,
    COUNT(sc.id_servizio) AS numero_servizi
FROM Controllo_di_sicurezza c
JOIN Servizio_Controllo sc ON c.id_controllo = sc.id_controllo
GROUP BY c.tipo_controllo
ORDER BY numero_servizi DESC;

-- Q19: Servizi senza processo di sicurezza associato
SELECT
    s.nome AS servizio
FROM Servizio s
LEFT JOIN Processo_Servizio ps ON s.id_servizio = ps.id_servizio
WHERE ps.id_processo IS NULL;

-- Q20: Formazioni attive per ambito
SELECT
    ambito,
    COUNT(*) AS numero_formazioni
FROM Formazione
WHERE stato = 'Attiva'
GROUP BY ambito;

-- Q21: Servizi con più asset critici associati
SELECT
    s.nome AS servizio,
    COUNT(a.id_asset) AS asset_critici
FROM Servizio s
JOIN Servizio_Asset sa ON s.id_servizio = sa.id_servizio
JOIN Asset a ON sa.id_asset = a.id_asset
WHERE a.criticita = 'Alta'
GROUP BY s.nome
HAVING COUNT(a.id_asset) > 1;

-- Q22: Asset critici utilizzati da più servizi
SELECT
    a.nome AS asset,
    COUNT(sa.id_servizio) AS numero_servizi
FROM Asset a
JOIN Servizio_Asset sa ON a.id_asset = sa.id_asset
WHERE a.criticita = 'Alta'
GROUP BY a.nome
HAVING COUNT(sa.id_servizio) > 1;

-- Q23: Servizi senza fornitore ma con asset critici
SELECT DISTINCT
    s.nome AS servizio
FROM Servizio s
JOIN Servizio_Asset sa ON s.id_servizio = sa.id_servizio
JOIN Asset a ON sa.id_asset = a.id_asset AND a.criticita = 'Alta'
LEFT JOIN Servizio_Fornitore sf ON s.id_servizio = sf.id_servizio
WHERE sf.id_fornitore IS NULL;

-- Q24: Servizi con controlli solo organizzativi (assenza di controlli tecnici)
SELECT
    s.nome AS servizio
FROM Servizio s
JOIN Servizio_Controllo sc ON s.id_servizio = sc.id_servizio
JOIN Controllo_di_sicurezza c ON sc.id_controllo = c.id_controllo
GROUP BY s.nome
HAVING SUM(CASE WHEN c.categoria_controllo = 'Tecnico' THEN 1 ELSE 0 END) = 0;

-- Q25: Servizi con esito assessment non conforme o parzialmente conforme
SELECT
    nome,
    esito_assessment
FROM Servizio
WHERE esito_assessment IN ('Parzialmente conforme', 'Non conforme');

-- Q26: Responsabili senza servizi assegnati
SELECT
    r.ruolo,
    r.area
FROM Responsabile r
LEFT JOIN Servizio_Responsabile sr ON r.id_responsabile = sr.id_responsabile
WHERE sr.id_servizio IS NULL;

-- Q27: Processi di sicurezza applicati a più servizi
SELECT
    p.nome AS processo,
    COUNT(ps.id_servizio) AS numero_servizi
FROM Processo p
JOIN Processo_Servizio ps ON p.id_processo = ps.id_processo
GROUP BY p.nome
HAVING COUNT(ps.id_servizio) > 1;

-- Q28: Servizi con asset critici associati ma senza controlli di sicurezza
SELECT DISTINCT
    s.nome AS servizio
FROM Servizio s
JOIN Servizio_Asset sa ON s.id_servizio = sa.id_servizio
JOIN Asset a ON sa.id_asset = a.id_asset AND a.criticita = 'Alta'
LEFT JOIN Servizio_Controllo sc ON s.id_servizio = sc.id_servizio
WHERE sc.id_controllo IS NULL;