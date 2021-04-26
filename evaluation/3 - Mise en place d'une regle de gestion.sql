-- 3) Mise en place d'une règle de gestion
-- Décrivez par quel moyen et comment vous pourriez implémenter la règle de gestion suivante.

-- Pour tenir compte des coûts liés au transport, on vérifiera que pour chaque produit d’une 
-- commande, le client réside dans le même pays que le fournisseur du même produit

DELIMITER |
    CREATE TRIGGER before_insert_orders_ville BEFORE INSERT ON orders
    FOR EACH ROW
    BEGIN
        IF NEW.ShipCountry NOT IN (
            SELECT suppliers.Country
            FROM `orders`
            JOIN order_details ON order_details.orderID = orders.OrderID
            JOIN products ON products.ProductID = order_details.ProductID
            JOIN suppliers ON suppliers.SupplierID = products.SupplierID
            WHERE orders.orderID = NEW.orderID
        )
        THEN 
            SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Le client ne réside pas dans le même pays que le fournisseur'; -- possibilité d'augmenter les frais, etc...
        END IF; 
    END |
DELIMITER ;

