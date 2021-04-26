-- A partir de l'exemple suivant, créez les déclencheurs suivants :

-- modif_reservation : interdire la modification des réservations (on autorise 
-- l'ajout et la suppression).

    DELIMITER |
    CREATE TRIGGER modif_reservation BEFORE UPDATE ON reservation	
    FOR EACH ROW    
    BEGIN        
        DECLARE prix INT;         
        SET prix = NEW.res_prix;    	
        IF 	prix != OLD.res_prix THEN       				
            SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Modification interdite par l administrateur';             
        END IF;     
    END | 
    DELIMITER ; 


-- insert_reservation : interdire l'ajout de réservation pour les hôtels possédant 
-- déjà 10 réservations.

    DELIMITER |
        CREATE TRIGGER insert_reservation BEFORE INSERT ON reservation
        FOR EACH ROW 
            BEGIN 
                DECLARE impossible_hot_id INT;
                SET impossible_hot_id = (
                    SELECT cha_hot_id 
                    FROM `reservation`
                    JOIN chambre ON res_cha_id = cha_id
                    GROUP BY cha_hot_id
                    HAVING COUNT(res_cha_id) >= 10
                    );
                IF NEW.res_cha_id = impossible_hot_id THEN 
                    SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Cet hotel à déjà 10 reservations ou plus';
                END IF;
            END |
    DELIMITER ; 

    -- Pour tester :

    INSERT INTO reservation (res_cha_id, res_cli_id, res_date, res_date_debut, res_date_fin, res_prix)
    VALUES (1, 1, '2017-01-10 00:00:00', '2017-01-10 00:00:00', '2017-01-10 00:00:00', 666); 

-- insert_reservation2 : interdire les réservations si le client possède déjà 3 
-- réservations.

   DELIMITER |
        CREATE TRIGGER insert_reservation2 BEFORE INSERT ON reservation
        FOR EACH ROW 
            BEGIN 
                IF NEW.res_cli_id IN (
                    SELECT res_cli_id
                    FROM `reservation`
                    GROUP BY res_cli_id
                    HAVING COUNT(res_cli_id) >= 3
                ) THEN 
                    SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Ce client à déjà 3 reservations ou plus';
                END IF;
            END |
    DELIMITER ; 

    -- Pour tester :

    INSERT INTO reservation (res_cha_id, res_cli_id, res_date, res_date_debut, res_date_fin, res_prix)
    VALUES (10, 1, '2017-01-10 00:00:00', '2017-01-10 00:00:00', '2017-01-10 00:00:00', 666);


-- insert_chambre : lors d'une insertion, on calcule le total des capacités des 
-- chambres pour l'hôtel, si ce total est supérieur à 50, on interdit l'insertion 
-- de la chambre.

    DELIMITER |
        CREATE TRIGGER insert_chambre BEFORE INSERT ON chambre
        FOR EACH ROW
            BEGIN
                    DECLARE total_capacite INT;
                    SET total_capacite = 
                    (
                    SELECT SUM(cha_capacite)
                    FROM `chambre`
                    WHERE cha_hot_id = NEW.cha_hot_id
                    GROUP BY cha_hot_id
                    ); 
                IF NEW.cha_capacite + total_capacite > 50 
                THEN 
                    SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Capacite maximale atteinte, impossible d ajouter une chambre';
                END IF;
            END |
    DELIMITER ;

    -- Pour tester :

    INSERT INTO chambre (cha_numero, cha_hot_id, cha_capacite, cha_type) 
    VALUES (001, 1, 50, 1);


-- Travail à réaliser
-- Mettez en place ce trigger, puis ajoutez un produit dans une commande, 
-- vérifiez que le champ total est bien mis à jour.
    
    DELIMITER |
        CREATE TRIGGER maj_total AFTER INSERT UPDATE DELETE ON lignedecommande
            FOR EACH ROW
            BEGIN
                DECLARE id_c INT;
                DECLARE tot DOUBLE;
                SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
                SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c); -- on recalcul le total
                UPDATE commande SET total=tot WHERE id=id_c; -- on stocke le total dans la table commande
        END |
    DELIMITER ; 

    -- Pour tester : 

    INSERT INTO lignedecommande (id_commande, id_produit, prix, quantite) VALUES (2, 3, 10, 2);

-- Ce trigger ne fonctionne que lorsque l'on ajoute des produits dans la commande, 
-- les modifications ou suppressions ne permettent pas de recalculer le total. 
-- Modifiez le code ci-dessus pour faire en sorte que la modification ou la 
-- suppression de produit recalcul le total de la commande.

    -- No. The fact that you're doing same things for different events means nothing in terms of triggers. 
    -- They are different events - so they should be different triggers – Alma Do

    DELIMITER |
        CREATE TRIGGER after_update_maj_total AFTER UPDATE ON lignedecommande
            FOR EACH ROW
            BEGIN
                DECLARE id_c INT;
                DECLARE tot DOUBLE;
                SET id_c = NEW.id_commande; 
                SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c);
                UPDATE commande SET total=tot WHERE id=id_c; 
        END |
    DELIMITER ; 

    -- Pour tester : 

    UPDATE lignedecommande 
    SET prix = 11
    WHERE id_commande = 3

    --

    DELIMITER |
        CREATE TRIGGER after_delete_maj_total AFTER DELETE ON lignedecommande
            FOR EACH ROW
            BEGIN
                DECLARE id_c INT;
                DECLARE tot DOUBLE;
                SET id_c = OLD.id_commande; -- Bien faire attention à utiliser OLD dans un DELETE
                SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c); 
                UPDATE commande SET total=tot WHERE id=id_c; 
        END |
    DELIMITER ; 

    -- Pour tester : 

    DELETE FROM lignedecommande
    WHERE id_produit = 1; 

-- Un champ remise était prévu dans la table commande. Prenez en compte ce champ 
-- dans le code de votre trigger.

    DELIMITER |
        CREATE TRIGGER after_update_maj_total AFTER UPDATE ON lignedecommande
            FOR EACH ROW
            BEGIN
                DECLARE id_c INT;
                DECLARE tot DOUBLE;
                DECLARE rem INT; 
                SET id_c = NEW.id_commande; 
                SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c);
                SET rem = (SELECT remise FROM commande WHERE id=id_c) ;
                UPDATE commande SET total=(tot-rem) WHERE id=id_c; 
        END |
    DELIMITER ; 

    -- Pour tester : 

    UPDATE lignedecommande 
    SET prix = 10
    WHERE id_commande = 3