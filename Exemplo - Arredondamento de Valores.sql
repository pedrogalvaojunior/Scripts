Declare @Valor Float

Set @Valor=152.125

Select Round(@Valor,2) As 'Duas Casas'

Select Round(@Valor,1) As 'Uma Casa'

Select Ceiling(@Valor) As 'Arrendondamento para Cima'

Select Floor(@Valor) As 'Arrendondamento para Baixo'
