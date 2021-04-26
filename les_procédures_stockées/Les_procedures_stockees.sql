-- Exercice 1 : création d'une procédure stockée sans paramètre

-- Créez la procédure stockée Lst_fournis correspondant à la requête n°2 afficher le code des 
-- fournisseurs pour lesquels une commande a été passée.

    DELIMITER |

    CREATE PROCEDURE Lst_fournis()

    BEGIN
        SELECT DISTINCT nomfou AS "Fournisseur"
        FROM `entcom`
        JOIN fournis ON fournis.numfou = entcom.numfou; 
    END |

    DELIMITER ; 

-- Exécutez la pour vérifier qu’elle fonctionne conformément à votre attente.

    CALL Lst_fournis();

-- Exécutez la commande SQL suivante pour obtenir des informations sur cette procédure stockée :

-- SHOW CREATE PROCEDURE nom_procedure;

    SHOW CREATE PROCEDURE Lst_fournis;

-- Exercice 2 : création d'une procédure stockée avec un paramètre en entrée
-- Créer la procédure stockée Lst_Commandes, qui liste les commandes ayant un libellé particulier dans le 
-- champ obscom (cette requête sera construite à partir de la requête n°11).

    DELIMITER |

    CREATE PROCEDURE Lst_Commandes(IN libelle VARCHAR(50))

    BEGIN
        SELECT numcom 
        FROM `entcom`
        WHERE obscom = libelle; 
    END |

    DELIMITER ; 
    
    -- Jeu de test : 

    CALL Lst_Commandes("Commande Urgente"); 

-- Exercice 3 : création d'une procédure stockée avec plusieurs paramètres
-- Créer la procédure stockée CA_Fournisseur, qui pour un code fournisseur et une année entrée 
-- en paramètre, calcule et restitue le CA potentiel de ce fournisseur pour l'année souhaitée 
-- (cette requête sera construite à partir de la requête n°19).

-- On exécutera la requête que si le code fournisseur est valide, c'est-à-dire dans la table FOURNIS.

    DELIMITER |

    CREATE PROCEDURE CA_Fournisseur(
        num_fournisseur int, 
        annee int
        )
    BEGIN 
        SELECT qtecde * priuni AS "Chiffre d'affaire"
        FROM `ligcom`
        JOIN vente ON ligcom.codart = vente.codart
        WHERE vente.numfou = num_fournisseur AND year(derliv) = annee;
    END |

    DELIMITER ; 

-- Testez cette procédure avec différentes valeurs des paramètres.

    Call CA_Fournisseur(120, 2007);  --OK
    Call CA_Fournisseur(121, 2007);  --KO 121 do not exists
    Call CA_Fournisseur(120, 2008);  --KO any data for year 2008