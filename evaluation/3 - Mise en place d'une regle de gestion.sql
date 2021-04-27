-- 3) Mise en place d'une règle de gestion
-- Décrivez par quel moyen et comment vous pourriez implémenter la règle de gestion suivante.

-- Pour tenir compte des coûts liés au transport, on vérifiera que pour chaque produit d’une 
-- commande, le client réside dans le même pays que le fournisseur du même produit


DELIMITER |
	CREATE TRIGGER before_insert_order_details BEFORE INSERT ON order_details
    FOR EACH ROW
    	BEGIN 
        	DECLARE ship_country CHARACTER; 
            DECLARE sup_country CHARACTER;
            SET ship_country = (
                SELECT orders.ShipCountry
                FROM `order_details`
                JOIN orders ON orders.OrderID = order_details.OrderID
                WHERE order_details.OrderID = NEW.OrderID 
                LIMIT 1
                ); 
            SET sup_country = (
                SELECT suppliers.Country
                FROM `order_details`
                JOIN products ON products.ProductID = order_details.ProductID
                JOIN suppliers ON suppliers.SupplierID = products.SupplierID
                WHERE order_details.ProductID = NEW.ProductID  
                LIMIT 1
                ); 
			IF ship_country != sup_country 
            THEN
            	SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Le client ne réside pas dans le même pays que le fournisseur'; -- possibilité d'augmenter les frais, etc...
        	END IF; 
		END |
DELIMITER ; 