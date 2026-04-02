-- Tabella Servizio
CREATE TABLE Servizio (
    id_servizio SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    criticita VARCHAR(20) NOT NULL CHECK (criticita IN ('Bassa', 'Media', 'Alta')),
    stato VARCHAR(30) NOT NULL,
    esito_assessment VARCHAR(30)
);

-- Tabella Asset
CREATE TABLE Asset (
    id_asset SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    tipo_asset VARCHAR(50),
    criticita VARCHAR(20) CHECK (criticita IN ('Bassa', 'Media', 'Alta')),
    stato VARCHAR(30)
);

-- Tabella Fornitore
CREATE TABLE Fornitore (
    id_fornitore SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_fornitura VARCHAR(100),
    criticita_dipendenza VARCHAR(20),
    stato VARCHAR(30) NOT NULL
);

-- Tabella Responsabile
CREATE TABLE Responsabile (
    id_responsabile SERIAL PRIMARY KEY,
    ruolo VARCHAR(100) NOT NULL,
    descrizione TEXT,
    area VARCHAR(50)
);

-- Tabella Controllo_di_sicurezza
CREATE TABLE Controllo_di_sicurezza (
    id_controllo SERIAL PRIMARY KEY,
    tipo_controllo VARCHAR(100) NOT NULL,
    categoria_controllo VARCHAR(50) CHECK (categoria_controllo IN ('Tecnico', 'Organizzativo')),
    stato VARCHAR(30),
    esito_assessment VARCHAR(30)
);

-- Tabella Processo
CREATE TABLE Processo (
    id_processo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    stato VARCHAR(30),
    esito_assessment VARCHAR(30)
);

-- Tabella Formazione
CREATE TABLE Formazione (
    id_formazione SERIAL PRIMARY KEY,
    tipo_formazione VARCHAR(100) NOT NULL,
    ambito VARCHAR(50),
    periodicita VARCHAR(30),
    stato VARCHAR(30)
);

-- Servizio - Asset
CREATE TABLE Servizio_Asset (
    id_servizio INT NOT NULL,
    id_asset INT NOT NULL,
    PRIMARY KEY (id_servizio, id_asset),
    FOREIGN KEY (id_servizio) REFERENCES Servizio(id_servizio) ON DELETE CASCADE,
    FOREIGN KEY (id_asset) REFERENCES Asset(id_asset) ON DELETE CASCADE
);

-- Servizio - Fornitore
CREATE TABLE Servizio_Fornitore (
    id_servizio INT NOT NULL,
    id_fornitore INT NOT NULL,
    PRIMARY KEY (id_servizio, id_fornitore),
    FOREIGN KEY (id_servizio) REFERENCES Servizio(id_servizio) ON DELETE CASCADE,
    FOREIGN KEY (id_fornitore) REFERENCES Fornitore(id_fornitore) ON DELETE CASCADE
);

-- Servizio - Responsabile
CREATE TABLE Servizio_Responsabile (
    id_servizio INT NOT NULL,
    id_responsabile INT NOT NULL,
    PRIMARY KEY (id_servizio, id_responsabile),
    FOREIGN KEY (id_servizio) REFERENCES Servizio(id_servizio) ON DELETE CASCADE,
    FOREIGN KEY (id_responsabile) REFERENCES Responsabile(id_responsabile) ON DELETE CASCADE
);

-- Servizio - Controllo di sicurezza
CREATE TABLE Servizio_Controllo (
    id_servizio INT NOT NULL,
    id_controllo INT NOT NULL,
    PRIMARY KEY (id_servizio, id_controllo),
    FOREIGN KEY (id_servizio) REFERENCES Servizio(id_servizio) ON DELETE CASCADE,
    FOREIGN KEY (id_controllo) REFERENCES Controllo_di_sicurezza(id_controllo) ON DELETE CASCADE
);

-- Processo - Servizio
CREATE TABLE Processo_Servizio (
    id_processo INT NOT NULL,
    id_servizio INT NOT NULL,
    PRIMARY KEY (id_processo, id_servizio),
    FOREIGN KEY (id_processo) REFERENCES Processo(id_processo) ON DELETE CASCADE,
    FOREIGN KEY (id_servizio) REFERENCES Servizio(id_servizio) ON DELETE CASCADE
);

-- Formazione - Responsabile
CREATE TABLE Formazione_Responsabile (
    id_formazione INT NOT NULL,
    id_responsabile INT NOT NULL,
    PRIMARY KEY (id_formazione, id_responsabile),
    FOREIGN KEY (id_formazione) REFERENCES Formazione(id_formazione) ON DELETE CASCADE,
    FOREIGN KEY (id_responsabile) REFERENCES Responsabile(id_responsabile) ON DELETE CASCADE
);

-- Indici
CREATE INDEX idx_servizio_criticita ON Servizio(criticita);
CREATE INDEX idx_asset_criticita ON Asset(criticita);
CREATE INDEX idx_fornitore_stato ON Fornitore(stato);

CREATE INDEX idx_sa_servizio ON Servizio_Asset(id_servizio);
CREATE INDEX idx_sa_asset ON Servizio_Asset(id_asset);

CREATE INDEX idx_sf_servizio ON Servizio_Fornitore(id_servizio);
CREATE INDEX idx_sf_fornitore ON Servizio_Fornitore(id_fornitore);

CREATE INDEX idx_sr_servizio ON Servizio_Responsabile(id_servizio);
CREATE INDEX idx_sr_responsabile ON Servizio_Responsabile(id_responsabile);

CREATE INDEX idx_sc_servizio ON Servizio_Controllo(id_servizio);
CREATE INDEX idx_sc_controllo ON Servizio_Controllo(id_controllo);

CREATE INDEX idx_ps_processo ON Processo_Servizio(id_processo);
CREATE INDEX idx_ps_servizio ON Processo_Servizio(id_servizio);

CREATE INDEX idx_fr_formazione ON Formazione_Responsabile(id_formazione);
CREATE INDEX idx_fr_responsabile ON Formazione_Responsabile(id_responsabile);
