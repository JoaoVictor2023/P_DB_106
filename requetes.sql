USE db_space_invaders;

-- 1. La première requête que l’on vous demande de réaliser est de sélectionner les 5 joueurs qui ont le meilleur score c’est-à-dire qui ont le nombre de points le plus élevé. Les joueurs doivent être classés dans l’ordre décroissant 

SELECT * 
FROM t_joueur 
ORDER BY (jouNombrePoints) DESC 
LIMIT 5;

-- 2. Trouver le prix maximum, minimum et moyen des armes. Les colonnes doivent avoir pour nom « PrixMaximum », « PrixMinimum » et « PrixMoyen) 


SELECT MAX(armPrix) AS PrixMax, 
AVG(armPrix) AS PrixMoyen, 
MIN(armPrix) AS PrixMin 
FROM t_arme ;


-- 3. Trouver le nombre total de commandes par joueur et trier du plus grand nombre au plus petit. La 1ère colonne aura pour nom "IdJoueur", la 2ème colonne aura pour nom "NombreCommandes" 

SELECT fkJoueur AS IdJoueur,
COUNT(*) AS NombreCommande 
FROM t_commande
GROUP BY(fkJoueur) ;

-- 4. Trouver les joueurs qui ont passé plus de 2 commandes. La 1ère colonne aura pour nom "IdJoueur", la 2ème colonne aura pour nom "NombreCommandes" 

SELECT fkJoueur AS IdJoueur,
COUNT(*) AS NombreCommande 
FROM t_commande
GROUP BY (fkJoueur)
HAVING COUNT(*) > 2;

-- 5. Trouver le pseudo du joueur et le nom de l'arme pour chaque commande. 

SELECT t_arme.armNom, 
t_joueur.jouPseudo 
FROM t_detail_commande, t_commande, t_joueur, t_arme
WHERE t_detail_commande.fkArme = t_arme.idArme 
AND t_detail_commande.fkCommande = t_commande.idCommande 
AND t_commande.fkJoueur = t_joueur.idJoueur ;


-- 6. Trouver le total dépensé par chaque joueur en ordonnant par le montant le plus élevé en premier, et limiter aux 10 premiers joueurs. La 1ère colonne doit avoir pour nom "IdJoueur" et la 2ème colonne "TotalDepense" 

SELECT t_joueur.jouPseudo, SUM(t_arme.armPrix) AS TotalDepense FROM t_detail_commande, t_commande, t_joueur, t_arme
WHERE t_detail_commande.fkArme = t_arme.idArme AND t_detail_commande.fkCommande = t_commande.idCommande AND t_commande.fkJoueur = t_joueur.idJoueur
GROUP BY t_joueur.jouPseudo
ORDER BY SUM(t_arme.armPrix) DESC
LIMIT 10 ;


-- 7. Récupérez tous les joueurs et leurs commandes, même s'ils n'ont pas passé de commande. Dans cet exemple, même si un joueur n'a jamais passé de commande, il sera quand même listé, avec des valeurs `NULL` pour les champs de la table `t_commande`. 

SELECT DISTINCT jouPseudo, IF(idCommande IS NULL, "NULL", idCommande) 
FROM t_joueur
JOIN t_commande
ON t_joueur.idJoueur = t_commande.fkJoueur ;


-- 8. Récupérer toutes les commandes et afficher le pseudo du joueur s’il existe, sinon afficher `NULL` pour le pseudo. 

SELECT DISTINCT idCommande, IF(t_joueur.jouPseudo IS NULL, "NULL", t_joueur.jouPseudo) 
FROM t_commande
JOIN t_joueur
ON t_joueur.idJoueur = t_commande.fkJoueur ;


-- 9. Trouver le nombre total d'armes achetées par chaque joueur (même si ce joueur n'a acheté aucune Arme). 

SELECT t_joueur.jouPseudo, 
SUM(IF(t_detail_commande.detQuantiteCommande IS NULL, "NULL", t_detail_commande.detQuantiteCommande)) AS nbArmes 
FROM t_joueur
JOIN t_commande
ON t_joueur.idJoueur = t_commande.fkJoueur
JOIN t_detail_commande
ON t_commande.idCommande = t_detail_commande.fkCommande
GROUP BY t_joueur.jouPseudo ;


-- 10. Trouver les joueurs qui ont acheté plus de 3 types d'armes différentes 

SELECT t_joueur.jouPseudo, COUNT(t_detail_commande.fkArme) 
FROM t_joueur
JOIN t_commande
ON t_joueur.idJoueur = t_commande.fkJoueur
JOIN t_detail_commande
ON t_commande.idCommande = t_detail_commande.fkCommande
GROUP BY t_joueur.jouPseudo
HAVING COUNT(DISTINCT t_detail_commande.fkArme) > 3;


-- GESTION DES UTILISATEURS 

-- ADMIN 

CREATE ROLE 'Admin';
GRANT ALL PRIVILEGES
ON *.*
TO 'Admin'
WITH GRANT OPTION;

-- JOUEUR 

CREATE ROLE 'Joueur';
GRANT SELECT 
ON t_arme 
TO 'Joueur';

GRANT INSERT, SELECT 
ON t_commande 
TO 'Joueur';

-- GESTIONNAIRE DE LA BOUTIQUE 

CREATE ROLE 'Gestionnaire de la boutique';
GRANT SELECT 
ON t_joueur 
TO 'Gestionnaire de la boutique';


GRANT ALL PRIVILEGES 
ON t_arme 
TO 'Gestionnaire de la boutique';

GRANT SELECT
ON t_commande
TO 'Gestionnaire de la boutique';
