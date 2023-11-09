-- Exemplo 1 - LTRIM() --
SELECT LTRIM('     Five spaces are at the beginning of this string.')
Go

-- Exemplo 2 - LTRIM() --
DECLARE @string_to_trim VARCHAR(60)

SET @string_to_trim = '     Five spaces are at the beginning of this string.'

SELECT @string_to_trim AS 'Original string', LTRIM(@string_to_trim) AS 'Without spaces'
Go

-- Exemplo 3 - TRIM() --
SELECT TRIM( '     test    ') AS Result
Go

-- Exemplo 4 - TRIM() --
SELECT TRIM( '.,! ' FROM '     #     test    .') AS Result
Go

-- Exemplo 5 - TRIM() --
SELECT TRIM(LEADING '.,! ' FROM  '     .#     test    .') AS Result
Go

-- Exemplo 6 - RTRIM() --
SELECT RTRIM('Removes trailing spaces.   ')
Go

-- Exemplo 7 - RTRIM() --
DECLARE @string_to_trim VARCHAR(60)

SET @string_to_trim = 'Four spaces are after the period in this sentence.    '

SELECT @string_to_trim + ' Next string.'
SELECT RTRIM(@string_to_trim) + ' Next string.'
Go