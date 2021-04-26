-- Procédures stockées
-- Codez deux procédures stockées correspondant aux requêtes 9 et 10. 
-- Les procédures stockées doivent prendre en compte les éventuels paramètres.

-- 9 – Depuis quelle date le client « Du monde entier » n’a plus commandé ?

    DELIMITER | 
        CREATE PROCEDURE der_commande_client(
            nom_client VARCHAR(50)
            )
        BEGIN 
            SELECT MAX(orderDate) AS "Dernière commande"
            FROM orders
            JOIN customers ON customers.CustomerID = orders.CustomerID
            WHERE customers.CompanyName = nom_client;
        END |
    DELIMITER ; 

    -- Pour tester : 

    CALL der_commande_client("Du monde entier");

-- 10 – Quel est le délai moyen de livraison en jours ?

    DELIMITER |
        CREATE PROCEDURE delais_livraison_moyen_pays(
            pays VARCHAR(30)
            )
            BEGIN 
                SELECT FLOOR(AVG(DATEDIFF(ShippedDate, OrderDate))) AS "Jours de livraison moyen"
                FROM `orders`
                GROUP BY ShipCountry
                HAVING ShipCountry = pays;
            END |
    DELIMITER ; 

    -- Pour tester : 

    CALL delais_livraison_moyen_pays("Austria")