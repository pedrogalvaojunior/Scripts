ALTER TABLE [dbo].[CUSTO] 
 ADD CONSTRAINT [FK_CODPRODUTO] FOREIGN KEY 
	                                         ([CODPROD] ) REFERENCES [CUSTOTAB] ([CODPROD]) ON UPDATE CASCADE
GO


ALTER TABLE CUSTO900..CUSTO
 DROP CONSTRAINT FK_CODPRODUTO

select * from custo
where codprod=' 2 211a 214'

alter table teste2
 add constraint fk_codigo foreign key (codteste1) references teste1(codigo) on delete cascade