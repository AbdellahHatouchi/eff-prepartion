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
CREATE TABLE But(
    idJoueur BIGINT,
    idMatch BIGINT,
    minute DATETIME DEFAULT now(),
    penalty VARCHAR(55),
    PRIMARY KEY (idJoueur,idMatch),
    Foreign Key (idMatch) REFERENCES `match`(idMatch),
    Foreign Key (idJoueur) REFERENCES joueur(idJoueur)
);