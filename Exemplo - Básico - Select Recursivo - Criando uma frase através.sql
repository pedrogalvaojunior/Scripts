Create Table myWords
(RowID Int,
 Word Varchar(20))
Go

Insert Into myWords Values(1, 'This'),(2, 'is'),(3, 'an'),(4, 'interesting'),
(5,'table')

Declare @Sentence as varchar(8000)
SET @Sentence = ''
SELECT @Sentence = @Sentence + word + ' '
                        FROM myWords
                        ORDER BY RowID

PRINT @Sentence