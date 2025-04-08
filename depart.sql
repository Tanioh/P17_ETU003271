create database db_s2_ETU003271;
use db_s2_ETU003271;

create table utilisateur_N (
    id int primary key auto_increment,
    nom varchar(50) not null,
    mdp VARCHAR(50)
);

DROP TABLE ligne_credit;

CREATE TABLE ligne_credit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(100) NOT NULL,
    montant DOUBLE NOT NULL,
    user_id INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES utilisateur_N(id)
);

CREATE TABLE depense (
    id INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(100) NOT NULL,
    montant DOUBLE NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES utilisateur_N(id)
);
insert into utilisateur_N(nom,mdp) values('user','1234');