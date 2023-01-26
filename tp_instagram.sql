-- Création de la table d'utilisateurs
CREATE TABLE IF NOT EXISTS users(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(100) NOT NULL,
    avatar VARCHAR(30),
    bio VARCHAR(100)
);

--Création de la table des photos
CREATE TABLE IF NOT EXISTS photos(
	id SERIAL PRIMARY KEY,
	user_id int REFERENCES users(id) ON DELETE SET NULL,
	url VARCHAR(100) NOT NULL,
	legende VARCHAR(500),
	latitude INT CHECK (latitude>=-90 AND latitude<=90),
	longitude INT CHECK (longitude>=-180 AND longitude<=180)
);

--Création de la table des commentaires
CREATE TABLE IF NOT EXISTS commentaires(
    id SERIAL PRIMARY KEY,
    photo_id INT REFERENCES photos(id) ON DELETE CASCADE,	
    user_id INT REFERENCES users(id) ON DELETE SET NULL,
    contenu VARCHAR(800) NOT NULL
);

--Création de la table des likes sur les photos
CREATE TABLE IF NOT EXISTS like_photos(
    id SERIAL PRIMARY KEY,
    photo_id INT REFERENCES photos(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE
);

--Création de la table des likes sur les commentaires
CREATE TABLE IF NOT EXISTS like_commentaires(
    id SERIAL PRIMARY KEY,
    commentaire_id INT REFERENCES commentaires(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE
);

--Création de la table des follows
CREATE TABLE IF NOT EXISTS follow(
    id SERIAL PRIMARY KEY,
    user_id_suiveur INT REFERENCES users(id) ON DELETE CASCADE,
    user_id_suivi INT REFERENCES users(id) ON DELETE CASCADE
);

--Ajout des utilisateurs
INSERT INTO users (nom, prenom, username, email, mot_de_passe, avatar, bio)
VALUES
    ('Vassail', 'Brice', 'v.brice', 'bricevsl@outlook.fr', '12344321', 'https://7yf.fr', 'Je suis Brice'),
	('Garin', 'Marina', 'Marin', 'marina.garin@gmail.com', '1458gg45', 'https://7yf.fr', 'Je suis Marina'),
	('Zamora', 'Yoann', 'Zoan', 'bricevsl@hotmail.com', '1dzuzd!d7', 'https://7yf.fr', 'Je suis Yoann'),
	('Lis', 'Christian', 'Chris.lis', 'Chris.lis4@gmail.com', 'dzqdz66!ML', 'https://7yf.fr', 'Je suis Chris');

--Ajout des photos
INSERT INTO photos(url, legende, latitude, longitude, user_id)
VALUES
    ('https://picsum.photos/536/350', 'Belle après - midi', '16', '175', 1),
	('https://picsum.photos/536/351', 'Le café', '86', '25', 2),
	('https://picsum.photos/536/352', 'Lo potit chat', '68', '46', 3),
	('https://picsum.photos/536/353', 'Ratatouille', '73', '21', 4),
	('https://picsum.photos/536/357', 'Bernie, quel farceur', '87', '112', 3);	

--Ajout des commentaires
INSERT INTO commentaires(photo_id, user_id, contenu)
VALUES
    (2, 1, 'T es charmante'),
    (4, 4, 'HAHA MDR'),
    (4, 1, 'L abus de photoshop...'),
    (3, 1, 'Trop mimi lo potit chat !!'),
    (2, 3, 'Je participe au concours !');

--Ajout des likes sur les photos
INSERT INTO like_photos (photo_id, user_id)
VALUES
	(2, 4),
	(3, 3),
	(4, 2),
	(5, 1),
	(1, 1),
	(2, 2),
	(3, 4),
	(4, 3),
	(5, 4);

--Ajout des likes sur les commentaires
INSERT INTO like_commentaires(commentaire_id, user_id)
VALUES
	(2,1),
	(2,2),
	(2,4),
	(3,1),
	(3,3),
	(1,4),
	(4,4),
	(5,2),
	(5,3),
	(1,1);

--Ajout des follows
INSERT INTO follow (user_id_suiveur, user_id_suivi)
VALUES
    (1, 1),(2, 1),(3, 1),(4, 1),(1, 2),(2, 2),(3, 2),
    (4, 2),(1, 3),(2, 3),(3, 3),(4, 3),(1, 4),(2, 4),
    (3, 4),(4, 4);

--4
-- Pour tous les commentaires, montrer le contenu et le username de l'auteur
SELECT contenu, users.username FROM commentaires 
JOIN users ON users.id=commentaires.user_id;

--5
-- Pour chaque commentaire, afficher son contenu et l'url de la photo à laquelle 
--le commentaire a été ajouté
SELECT contenu, url FROM commentaires
JOIN photos ON photos.id=commentaires.photo_id;

--6
-- Afficher l'url de chaque photo et le nom d'utilisateur de l'auteur
SELECT username, photos.url
FROM users JOIN photos ON users.id=photos.user_id;

--7
-- Trouver tous les commentaires pour la photo d'id 3, avec le username de 
--l'utilisateur qui a commenté
SELECT photos.id, contenu, users.username
FROM commentaires
JOIN photos ON photos.id=commentaires.photo_id
JOIN users ON users.id=commentaires.user_id
WHERE photos.id = 3;

--8
--Trouver tous les url des photos ainsi que tous les commentaires qui ont été posté 
--par l'auteur de la photo
SELECT username, photos.url, commentaires.contenu
FROM users
JOIN photos ON users.id=photos.user_id
JOIN commentaires ON photos.id=commentaires.photo_id;

--9
--A l'exercice précédent afficher aussi le nom de l'utilisateur qui a commenté ses propres photos
SELECT username, photos.url, commentaires.contenu
FROM users 
JOIN photos ON users.id=photos.user_id
JOIN commentaires ON photos.id=commentaires.photo_id 
WHERE commentaires.user_id = photos.user_id;

--10
-- Le nombre de likes pour la photo d’ID 4
SELECT COUNT(*) AS nombre_likes FROM like_photos JOIN photos 
ON photos.id=like_photos.photo_id WHERE photos.id=4;