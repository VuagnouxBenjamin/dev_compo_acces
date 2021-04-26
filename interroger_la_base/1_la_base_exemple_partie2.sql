-- 1. Calculer le nombre d'employés de chaque titre.

    SELECT 
        titre, 
        COUNT(noemp) 
    FROM 
        `employe`
    GROUP BY 
        titre

-- 2. Calculer la moyenne des salaires et leur somme, par région.

    SELECT 
        AVG(salaire) AS "Moyenne des salaires",  
        SUM(salaire) AS "Somme des salaires", 
        dept.nom AS "Département"
    FROM 
        `employe`
    JOIN 
        dept ON dept.nodept = employe.nodep
    GROUP BY 
        nodep

-- 3. Afficher les numéros des départements ayant au moins 3 employés.

    SELECT nodep, count(noemp) AS "Employés concernés"
    FROM `employe`
    GROUP BY nodep
    HAVING count(noemp) >= 3

-- 4. Afficher les lettres qui sont l'initiale d'au moins trois employés.


    SELECT SUBSTR(nom, 1, 1) AS "Initiale", count(noemp) AS "Employés concernés"
    FROM `employe`
    GROUP BY SUBSTR(nom, 1, 1)
    HAVING count(noemp) >= 3

-- 5. Rechercher le salaire maximum et le salaire minimum parmi tous les
-- salariés et l'écart entre les deux.

    SELECT MAX(salaire) AS "Salaire MAX", MIN(salaire) AS "Salaire MIN", (MAX(salaire) -  MIN(salaire)) AS "Ecart"
    FROM `employe`

-- 6. Rechercher le nombre de titres différents.

    SELECT COUNT(DISTINCT titre) AS "Nombre de titres"
    FROM `employe`

-- 7. Pour chaque titre, compter le nombre d'employés possédant ce titre.

    SELECT titre, COUNT(noemp) AS "Nombre d'employé.e.s concerné.e.s"
    FROM `employe`
    GROUP BY titre

-- 8. Pour chaque nom de département, afficher le nom du département et
-- le nombre d'employés.

    SELECT dept.nom, COUNT(noemp) AS "Nombre d'employé.e.s"
    FROM `employe`
    JOIN dept on nodep = nodept
    GROUP BY dept.nom

-- 9. Rechercher les titres et la moyenne des salaires par titre dont la
-- moyenne est supérieure à la moyenne des salaires des Représentants.

    SELECT titre, AVG(salaire) 
    FROM `employe`
    GROUP BY titre 
    HAVING AVG(salaire) > 
    (
        SELECT AVG(salaire) 
        FROM employe
        WHERE titre = 'représentant'
    )

-- 10.Rechercher le nombre de salaires renseignés et le nombre de taux de
-- commission renseignés. 

    SELECT count(salaire) AS "Salaires renseignés", count(tauxcom) AS "Tx commission renseignés"
    FROM `employe`
