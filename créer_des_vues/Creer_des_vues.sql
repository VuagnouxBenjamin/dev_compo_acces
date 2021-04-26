-- Exercice 1 : vues sur la base hotel
-- A partir de la base hotel, créez les vues suivantes :

-- Afficher la liste des hôtels avec leur station

    CREATE VIEW v_hot_station
    AS 
        SELECT hot_nom, sta_nom 
        FROM `hotel` 
        JOIN station ON hot_sta_id = sta_id

-- Afficher la liste des chambres et leur hôtel

    CREATE VIEW v_cha_hot
    AS
        SELECT cha_numero, hot_nom
        FROM `chambre`
        JOIN hotel ON cha_hot_id = hot_id

-- Afficher la liste des réservations avec le nom des clients

    CREATE VIEW v_cli_res
    AS
        SELECT res_date, cli_nom 
        FROM `reservation`
        JOIN client ON res_cli_id = cli_id

-- Afficher la liste des chambres avec le nom de l’hôtel et le nom de la station

    CREATE VIEW v_cha_hot_sta
    AS
        SELECT cha_numero, hot_nom, sta_nom
        FROM `chambre`
        JOIN hotel ON cha_hot_id = hot_id
        JOIN station ON hot_sta_id = sta_id

-- Afficher les réservations avec le nom du client et le nom de l’hôtel

    CREATE VIEW v_res_cli_hot
    AS
        SELECT res_date, cli_nom, hot_nom 
        FROM `reservation`
        JOIN client ON res_cli_id = cli_id 
        JOIN chambre ON res_cha_id = cha_id
        JOIN hotel ON cha_hot_id = hot_id


-- Exercice 2 : vues sur la base papyrus
-- Réalisez les vues suivantes sur papyrus:

-- v_GlobalCde correspondant à la requête : A partir de la table Ligcom, afficher par code produit, 
-- la somme des quantités commandées et le prix total correspondant : on nommera la colonne 
-- correspondant à la somme des quantités commandées, QteTot et le prix total, PrixTot.

    CREATE VIEW v_GlobalCde
    AS
        SELECT codart AS CdProduit, SUM(qtecde) AS QteTot, SUM(qtecde * priuni) AS PrixTot
        FROM `ligcom`
        GROUP BY codart

-- v_VentesI100 correspondant à la requête : Afficher les ventes dont le code produit est le 
-- I100 (affichage de toutes les colonnes de la table Vente).

    CREATE VIEW v_VentesI100
    AS
        SELECT * FROM `vente`
        WHERE codart = 'I100'

-- A partir de la vue précédente, créez v_VentesI100Grobrigan remontant toutes les ventes concernant 
-- le produit I100 et le fournisseur 00120.

    CREATE VIEW v_VentesI100Grobrigan
    AS
        SELECT codart, vente.numfou, delliv, qte1, prix1, qte2, prix2, qte3, prix3 
        FROM `vente`
        JOIN fournis ON vente.numfou = fournis.numfou
        WHERE codart = 'I100' AND nomfou = 'grobrigan'
