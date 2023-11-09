dECLARE @usr char(30)
SET @usr = user
Print 'The current user''s database username is: '+ @usr

SELECT 'The current user is: '+ convert(char(30), CURRENT_USER)

SELECT user_name(05)


