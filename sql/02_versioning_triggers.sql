-- Tabella di audit per lo storico delle modifiche
CREATE TABLE Audit_Log (
    id_audit SERIAL PRIMARY KEY,
    nome_tabella VARCHAR(50) NOT NULL,
    operazione VARCHAR(10) NOT NULL,
    record_id INT,
    dati_precedenti JSONB,
    dati_nuovi JSONB,
    data_operazione TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Funzione trigger per audit sulla tabella Servizio
CREATE OR REPLACE FUNCTION audit_trigger_servizio()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO Audit_Log (
            nome_tabella,
            operazione,
            record_id,
            dati_nuovi
        )
        VALUES (
            TG_TABLE_NAME,
            TG_OP,
            NEW.id_servizio,
            to_jsonb(NEW)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO Audit_Log (
            nome_tabella,
            operazione,
            record_id,
            dati_precedenti,
            dati_nuovi
        )
        VALUES (
            TG_TABLE_NAME,
            TG_OP,
            NEW.id_servizio,
            to_jsonb(OLD),
            to_jsonb(NEW)
        );
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO Audit_Log (
            nome_tabella,
            operazione,
            record_id,
            dati_precedenti
        )
        VALUES (
            TG_TABLE_NAME,
            TG_OP,
            OLD.id_servizio,
            to_jsonb(OLD)
        );
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger sulla tabella Servizio
CREATE TRIGGER trg_audit_servizio
AFTER INSERT OR UPDATE OR DELETE ON Servizio
FOR EACH ROW
EXECUTE FUNCTION audit_trigger_servizio();
