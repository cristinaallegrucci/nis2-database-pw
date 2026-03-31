-- Vista di supporto per esportazione dati profilo ACN
CREATE OR REPLACE VIEW v_export_acn AS
SELECT
    s.id_servizio,
    s.nome AS servizio,
    s.criticita AS criticita_servizio,

    STRING_AGG(DISTINCT a.nome, ', ') 
        FILTER (WHERE a.criticita = 'Alta') AS asset_critici,

    STRING_AGG(DISTINCT f.nome, ', ') AS fornitori,

    STRING_AGG(DISTINCT r.ruolo, ', ') AS punti_di_contatto,

    STRING_AGG(DISTINCT c.tipo_controllo, ', ') AS controlli_sicurezza,

    STRING_AGG(DISTINCT p.nome, ', ') AS processi_sicurezza

FROM Servizio s
LEFT JOIN Servizio_Asset sa ON s.id_servizio = sa.id_servizio
LEFT JOIN Asset a ON sa.id_asset = a.id_asset
LEFT JOIN Servizio_Fornitore sf ON s.id_servizio = sf.id_servizio
LEFT JOIN Fornitore f ON sf.id_fornitore = f.id_fornitore
LEFT JOIN Servizio_Responsabile sr ON s.id_servizio = sr.id_servizio
LEFT JOIN Responsabile r ON sr.id_responsabile = r.id_responsabile
LEFT JOIN Servizio_Controllo sc ON s.id_servizio = sc.id_servizio
LEFT JOIN Controllo_di_sicurezza c ON sc.id_controllo = c.id_controllo
LEFT JOIN Processo_Servizio ps ON s.id_servizio = ps.id_servizio
LEFT JOIN Processo p ON ps.id_processo = p.id_processo

GROUP BY s.id_servizio, s.nome, s.criticita
ORDER BY s.nome;