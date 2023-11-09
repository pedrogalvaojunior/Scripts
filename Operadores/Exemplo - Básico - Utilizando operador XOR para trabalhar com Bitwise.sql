-- Exemplo 1 --
declare @a int = 1, @b int = 100

select (@a ^ @b) ^ ((@a ^ @b) ^ @b), (@a ^ @b) ^ @b

-- Exemplo 2 --
declare @a int = 1, @b int = 100

select @a = @a ^ @b
select @b = @a ^ @b
select @a = @a ^ @b

select @a, @b