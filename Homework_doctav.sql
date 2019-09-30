--1. Create a database
--MOVIE_DB


--2. Create a table called Director with following columns: FirstName, LastName, Nationality and Birthdate. Insert 5 rows into it.

DROP TABLE MovieGenre;
DROP TABLE MovieActor;
DROP TABLE Movie;
DROP TABLE Director;
DROP TABLE Genre;

CREATE TABLE Director (
	Id int Identity(1,1) PRIMARY KEY,
	FirstName varchar(30),
	LastName varchar(30),
	Nationality varchar(20),
	Birthdate Date
);

DELETE FROM Director;

INSERT INTO Director(FirstName,LastName,Nationality,Birthdate) VALUES('First1','Last1','Nat1',CONVERT(DATETIME,'2019-01-01',102));
INSERT INTO Director(FirstName,LastName,Nationality,Birthdate) VALUES('First2','Last2','Nat2',CONVERT(DATETIME,'2019-12-25',102));
INSERT INTO Director(FirstName,LastName,Nationality,Birthdate) VALUES('First3','Last3','Nat1',CONVERT(DATETIME,'2018-09-17',102));
INSERT INTO Director(FirstName,LastName,Nationality,Birthdate) VALUES('First4','Last4','Nat3',CONVERT(DATETIME,'2019-11-09',102));
INSERT INTO Director(FirstName,LastName,Nationality,Birthdate) VALUES('First5','Last5','Nat1',CONVERT(DATETIME,'2019-11-21',102));

SELECT * FROM Director;

--3. Delete the director with id = 3
DELETE FROM Director WHERE Id=3;
SELECT * FROM Director;

--4. Create a table called Movie with following columns: DirectorId, Title, ReleaseDate, Rating and Duration. Each movie has a director. Insert some rows into it
CREATE TABLE Movie (
	Id int Identity(1,1) PRIMARY KEY,
	DirectorId int CONSTRAINT fk_DirectorID REFERENCES Director(id),
	Title VARCHAR(MAX),
	ReleaseDate DATE,
	Rating int CHECK (Rating>=0 AND Rating<=10),
	Duration int
);

INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(2,'Pe aripile vantului',CONVERT(DATETIME,'2019-03-22',102),7,120);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(1,'Movie2',CONVERT(DATETIME,'2019-03-22',102),9,90);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(2,'Movie3',CONVERT(DATETIME,'2016-03-12',102),10,100);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(1,'Movie4',CONVERT(DATETIME,'2014-12-21',102),10,80);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(1,'Movie5',CONVERT(DATETIME,'2009-03-02',102),7,45);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(4,'Movie6',CONVERT(DATETIME,'2002-07-02',102),8,55);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(1,'Movie7',CONVERT(DATETIME,'2001-04-14',102),10,118);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(2,'Movie8',CONVERT(DATETIME,'2000-09-17',102),9,85);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(5,'Movie9',CONVERT(DATETIME,'2016-03-22',102),6,100);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES(2,'Superman',CONVERT(DATETIME,'2017-03-15',102),8,95);
SELECT * FROM Movie;

--5. Update all movies that have a rating lower than 10.
UPDATE Movie SET Title='ArtificiallyUpdated' WHERE Rating<10;
SELECT * FROM Movie;


--6. Create a table called Actor with following columns: FirstName, LastName, Nationality, Birth date and PopularityRating. Insert some rows into it.
CREATE TABLE Actor (
	Id int Identity(1,1) PRIMARY KEY,
	FirstName VARCHAR(MAX) NOT NULL,
	LastName VARCHAR(MAX) NOT NULL,
	Nationality VARCHAR(MAX),
	BirtDate DATE,
	PopularityRating int CHECK (PopularityRating>=0 AND PopularityRating<=10)
);
INSERT INTO Actor(FirstName,LastName,Nationality,BirtDate,PopularityRating) VALUES ('First1','Last1','RO',CONVERT(DATETIME,'2000-11-27',102),8);
INSERT INTO Actor(FirstName,LastName,Nationality,BirtDate,PopularityRating) VALUES ('First2','Last2','DE',CONVERT(DATETIME,'1978-10-17',102),10);
INSERT INTO Actor(FirstName,LastName,Nationality,BirtDate,PopularityRating) VALUES ('First3','Last3','CN',CONVERT(DATETIME,'2001-12-07',102),9);
INSERT INTO Actor(FirstName,LastName,Nationality,BirtDate,PopularityRating) VALUES ('First4','Last4','RO',CONVERT(DATETIME,'2002-08-13',102),6);
INSERT INTO Actor(FirstName,LastName,Nationality,BirtDate,PopularityRating) VALUES ('First5','Last5','MD',CONVERT(DATETIME,'2003-04-15',102),7);
INSERT INTO Actor(FirstName,LastName,Nationality,BirtDate,PopularityRating) VALUES ('First6','Last6','RO',CONVERT(DATETIME,'2004-12-02',102),8);
INSERT INTO Actor(FirstName,LastName,Nationality,BirtDate,PopularityRating) VALUES ('First7','Last7','MD',CONVERT(DATETIME,'2005-11-23',102),10);
SELECT * FROM Actor;

--7. Which is the movie with the lowest rating?
SELECT CONCAT('Id=', Id, 'Title=',  Title, 'Rating=', Rating) AS MovieInfo
FROM MOVIE
WHERE Rating = (SELECT MIN(Rating) FROM Movie)


--8. Which director has the most movies directed?
SELECT DirectorId, COUNT(Id) AS NumberOfDirectedMovies
FROM Movie
GROUP BY DirectorId
HAVING COUNT(Id) >= ALL (SELECT COUNT(Id) FROM Movie GROUP BY DirectorId)


--9. Display all movies ordered by director's LastName in ascending order, then by birth date descending.
SELECT * 
FROM Movie m INNER JOIN Director d ON m.DirectorId=d.Id
ORDER BY d.LastName ASC, d.BirthDate DESC

--12. Create a stored procedure that will increment the rating by 1 for a given movie id.


--15. Implement many to many relationship between Movie and Actor
CREATE TABLE MovieActor (
	MovieId int CONSTRAINT fk_movie REFERENCES Movie(Id),
	ActorId int CONSTRAINT fk_actor REFERENCES Actor(Id)
);

INSERT INTO MovieActor(MovieId,ActorId) VALUES(1,5);
SELECT * FROM MovieActor;

--16. Implement many to many relationship between Movie and Genre
CREATE TABLE Genre(
	Id int IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(MAX) NOT NULL
);

CREATE TABLE MovieGenre(
	MovieId int CONSTRAINT fk_movieId REFERENCES Movie(Id),
	GenreId int CONSTRAINT fk_genreId REFERENCES Genre(Id)
);

INSERT INTO Genre(Name) VALUES('Romantic');
INSERT INTO Genre(Name) VALUES('Comedy');
SELECT * FROM Genre;

INSERT INTO MovieGenre(MovieId,GenreId) VALUES(2,1);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(5,2);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(1,2);

--17. Which actor has worked with the most distinct movie directors?
SELECT A.Id, COUNT(d.Id) AS NoOfDirs
FROM Actor A INNER JOIN MovieActor ma ON A.Id=ma.ActorId INNER JOIN Movie m ON ma.MovieId =m.Id INNER JOIN Director d ON m.DirectorId=d.Id
GROUP BY A.Id
HAVING COUNT(d.Id) >= (SELECT COUNT(d.Id) AS NoOfDirs
FROM Actor A INNER JOIN MovieActor ma ON A.Id=ma.ActorId INNER JOIN Movie m ON ma.MovieId =m.Id INNER JOIN Director d ON m.DirectorId=d.Id
GROUP BY A.Id)

--18. Which is the preferred genre of each actor?
SELECT A.FirstName, A.LastName,g.Name
FROM Actor A INNER JOIN MovieActor ma ON A.Id=ma.ActorId INNER JOIN Movie m ON ma.MovieId =m.Id INNER JOIN MovieGenre mg ON m.Id=mg.MovieId INNER JOIN Genre g ON mg.GenreId=g.Id


