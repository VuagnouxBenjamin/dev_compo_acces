-- Création d'un déclencheur AFTER UPDATE
-- Créer une table ARTICLES_A_COMMANDER avec les colonnes :

-- CODART : Code de l'article, voir la table produit
-- DATE : date du jour (par défaut)
-- QTE : à calculer
-- Créer un déclencheur UPDATE sur la table produit : lorsque le stock physique devient 
-- inférieur ou égal au stock d'alerte, une nouvelle ligne est insérée dans la table 
-- ARTICLES_A_COMMANDER.

-- Attention, il faut prendre en compte les quantités déjà commandées dans la table 
-- ARTICLES_A_COMMANDER .

    -- Table articles_a_commander 
    
    CREATE TABLE articles_a_commander (
        codart VARCHAR(10) PRIMARY KEY NOT NULL REFERENCES produit(codart), 
        date DATETIME NOT NULL, 
        qte INT NOT NULL
    )

    -- Trigger

    DELIMITER |
        CREATE TRIGGER after_update_art_a_com AFTER UPDATE ON produit 
            FOR EACH ROW
            BEGIN 
                IF NEW.stkphy <= NEW.stkale THEN 
                    INSERT INTO articles_a_commander (codart, date, qte)
                    VALUES (NEW.codart, NOW(), (NEW.stkale - NEW.stkphy));        
                END IF; 
            END |
    DELIMITER ; 

    -- Pour tester : 

    UPDATE produit
    SET stkphy = 15
    WHERE codart = 'P220'
