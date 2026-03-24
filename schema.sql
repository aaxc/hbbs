-- Izveidot datubāzi, ja vēl nav
CREATE DATABASE IF NOT EXISTS hbbs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hbbs;

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(255) PRIMARY KEY,
    role VARCHAR(50) DEFAULT 'voter',
    nominets TINYINT(1) DEFAULT 0,
    balsots TINYINT(1) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS timestamps (
    period VARCHAR(50) PRIMARY KEY,
    start BIGINT NOT NULL DEFAULT 0,
    end BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS nominacijas (
    id VARCHAR(36) PRIMARY KEY,
    tips ENUM('skolenu', 'skolotaju') NOT NULL,
    virsraksts VARCHAR(255) NOT NULL,
    apraksts TEXT
);

CREATE TABLE IF NOT EXISTS skoleni (
    grupa VARCHAR(50) NOT NULL,
    vards VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS skolotaji (
    grupa VARCHAR(50) NOT NULL,
    vards VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS karta1 (
    userID VARCHAR(255) NOT NULL,
    nominID VARCHAR(36) NOT NULL,
    izvele VARCHAR(255) NOT NULL,
    FOREIGN KEY (userID) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (nominID) REFERENCES nominacijas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS karta2 (
    userID VARCHAR(255) NOT NULL,
    nominID VARCHAR(36) NOT NULL,
    izvele VARCHAR(255) NOT NULL,
    FOREIGN KEY (userID) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (nominID) REFERENCES nominacijas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS finalists (
    nominID VARCHAR(36) NOT NULL,
    vards VARCHAR(255) NOT NULL,
    FOREIGN KEY (nominID) REFERENCES nominacijas(id) ON DELETE CASCADE
);

INSERT IGNORE INTO timestamps (period, start, end) VALUES 
('nominacijas', 0, 0),
('balsosana', 0, 0);

-- Piezīme: Lai varētu autorizēties un izmantot vadības paneli, IR jāizveido administratora konts ar zemāk redzamo komandu un tad jāpievieno šim failam beigās. Vispirms nepieciešams node.js, ja nav. Tiks izveidots admin konts admin:admin123. Paroli pēc tam var nomainīt no administratora paneļa.
-- node -e "const { scryptSync, randomBytes } = require('crypto'); const salt = randomBytes(16).toString('hex'); const hash = scryptSync('admin123', salt, 64).toString('hex'); console.log(\`INSERT INTO users (id, role, nominets, balsots) VALUES ('admin:\${hash}.\${salt}', 'admin', 0, 0);\`);"