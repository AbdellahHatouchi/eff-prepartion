CREATE DATABASE BotolaPro2023;

use BotolaPro2023;

-- ▪ Stade (idStade, ville, nom, nbPlaces, prixBillet)
-- ▪ Equipe (idEquipe, pays, siteWeb, entraîneur)
-- ▪ Joueur (idJoueur, idEquipe,position, nom, prénom, âge,nombrebut)
-- ▪ Match(idMatch, idStade,dateMatch, idEquipe1, idEquipe2,scoreEquipe1, scoreEquipe2, 
-- nbBilletsVendus)
-- ▪ But (idJoueur, idMatch, minute, penalty)

CREATE TABLE stade (
    idStade BIGINT PRIMARY KEY AUTO_INCREMENT,
    ville VARCHAR(55),
    nom VARCHAR(55),
    nbPlaces INT UNSIGNED,
    prixBillet DECIMAL(8,2) UNSIGNED
);


CREATE TABLE equipe(
    idEquipe BIGINT PRIMARY KEY AUTO_INCREMENT,
    pays VARCHAR(55),
    siteweb VARCHAR(255),
    entraineur VARCHAR(65)
);

CREATE TABLE Joueur(
    idJoueur BIGINT PRIMARY KEY AUTO_INCREMENT,
    idEquipe BIGINT,
    position VARCHAR(25),
    nom VARCHAR(55),
    prenom VARCHAR(55),
    age INT UNSIGNED,
    nombreBut INT UNSIGNED,
    Foreign Key (idEquipe) REFERENCES equipe(idEquipe)
);

ALTER TABLE joueur CHANGE COLUMN nombreBut nomberBut INT UNSIGNED DEFAULT 0;
ALTER TABLE joueur ADD CONSTRAINT check_age CHECK (`age` > 18);

CREATE TABLE `match`(
    idMatch BIGINT PRIMARY KEY AUTO_INCREMENT,
    idStade BIGINT,
    dateMatch DATETIME,
    idEquipeOne BIGINT,
    idEquipeTwo BIGINT,
    scoreEquipeOne INT UNSIGNED DEFAULT 0,
    scoreEquipeTwo INT UNSIGNED DEFAULT 0,
    nbBilletVendus INT UNSIGNED,
    FOREIGN KEY (idStade) REFERENCES stade(idStade),
    FOREIGN KEY (idEquipeOne) REFERENCES equipe(idEquipe),
    FOREIGN KEY (idEquipeTwo) REFERENCES equipe(idEquipe),
    CONSTRAINT CHK_DifferentTeams CHECK (idEquipeOne <> idEquipeTwo)
);
INSERT INTO `match` (idStade, dateMatch, idEquipeOne, idEquipeTwo, scoreEquipeOne, scoreEquipeTwo, nbBilletVendus)
SELECT
    FLOOR(RAND() * 10) + 1,
    NOW(),
    FLOOR(RAND() * 5) + 1,
    FLOOR(RAND() * 5) + 5,
    FLOOR(RAND() * 5),
    FLOOR(RAND() * 5),
    FLOOR(RAND() * 100)
FROM
    information_schema.tables
LIMIT 10;

CREATE TABLE But(
    idJoueur BIGINT,
    idMatch BIGINT,
    minute INT CHECK (minute >= 0),
    penalty VARCHAR(55),
    PRIMARY KEY (idJoueur,idMatch),
    Foreign Key (idMatch) REFERENCES `match`(idMatch),
    Foreign Key (idJoueur) REFERENCES joueur(idJoueur)
);

INSERT INTO But (idJoueur, idMatch, minute, penalty)
SELECT
    FLOOR(RAND() * 10) + 1,
    FLOOR(RAND() * 10) + 1,
    FLOOR(RAND() * 90),
    IF(RAND() < 0.5, 'Oui', 'Non')
FROM
    information_schema.tables
LIMIT 1;
-- Noms des joueurs âgés de plus de 30 ans qui ont marqué un but pour le match dont l’idMatch=2
SELECT j.nom FROM joueur as j INNER JOIN but as b ON j.`idJoueur` = b.`idJoueur` WHERE (j.age > 30 AND b.`idMatch` = 8);

CREATE VIEW countJoueurParMatch AS SELECT `idMatch` ,COUNT(DISTINCT `idJoueur`) FROM but GROUP BY `idMatch`;
SELECT * FROM countjoueurparmatch;

DELIMITER //
CREATE FUNCTION recette_match(match_id INT) RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE recette_match DECIMAL(12,2);
    SELECT (m.nbBilletVendus * s.prixBillet) INTO recette_match FROM `match` as m INNER JOIN stade as s ON m.`idStade` = s.`idStade` WHERE m.`idMatch` = match_id;
    RETURN recette_match;
END //
DELIMITER;

SELECT recette_match(9);

DELIMITER //
CREATE FUNCTION getNbBilletVendus(match_id INT ,stade_id INT)
RETURNS INT
READS SQL DATA
BEGIN
DECLARE nbrBilleV INT;
SELECT nbBilletVendus INTO nbrBilleV FROM `match` WHERE (idStade = stade_id AND idMatch = match_id);
RETURN nbrBilleV;
END//
DELIMITER ;

SELECT getNbBilletVendus(9,10);