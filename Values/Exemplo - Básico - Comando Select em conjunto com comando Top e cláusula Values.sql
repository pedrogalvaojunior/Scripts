SELECT TOP 1 answer = SomeName
FROM (VALUES ('Ebenezer Scrooge', 'A Christmas Carol', 'Old', 'Fiction', 'London'),
             ('Dumbledore', 'Harry Potter and the Sorcerer''s Stone', 'Very Old', 'Fantasy', 'Hogwarts'),
	     ('Frosty', 'Frosty The Snowman', 'Infant', 'Animated', 'A small town'),
	     ('Buddy', 'Elf', 'Teenage', 'Comedy', 'New York')
     ) AS a (SomeName, Movie, Age, Genre, Locale)
ORDER BY Age Desc
Go