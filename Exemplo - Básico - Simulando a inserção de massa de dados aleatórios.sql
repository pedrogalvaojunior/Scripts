-- Exemplo 1 --
Create Table RandomDataTable
  (ID int IDENTITY(1,1) NOT NULL Primary Key,
   CustomerID int NOT NULL,
   SalesPersonID varchar(10) NOT NULL,
   Quantity smallint NOT NULL,
   NumericValue numeric(18, 2) NOT NULL,
   Today date NOT NULL)
Go

--Inserting the data mass into the RandomDataTable --
Declare @Text Char(130), 
             @Position TinyInt, 
		     @RowCount Int

Set @Text = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzŽŸ¡ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïðñòóôõöùúûüýÿ.;^' --There are 130 characters in this text--

Set @RowCount = Rand()*100000 -- Set the amount of lines to be inserted --

While (@RowCount >=1)
Begin

 Set @Position=Rand()*130

   Insert Into RandomDataTable (CustomerID, SalesPersonID, Quantity, NumericValue, Today)
   Values(@RowCount, 
                 Concat(SubString(@Text,@Position+2,2),SubString(@Text,@Position-4,4),SubString(@Text,@Position+2,4)),
                 Rand()*1000, 
	             Rand()*100+5, 
	             DATEADD(d, 1000*Rand() ,GetDate()))
       Set @RowCount = @RowCount - 1
End

Select ID, CustomerID, SalesPersonID, Quantity, NumericValue, Today 
From RandomDataTable
Go

-- Exemplo 2 --
Create Table RandomDataTable
  (ID int IDENTITY(1,1) NOT NULL Primary Key,
   CustomerID int NOT NULL,
   SalesPersonID varchar(10) NOT NULL,
   Quantity smallint NOT NULL,
   NumericValue numeric(8, 2) NOT NULL,
   Today date NOT NULL)
Go


--Inserting the data mass into the RandomDataTable --
Declare @Text Char(130), 
             @RowCount Int

Set @Text = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzŽŸ¡ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïðñòóôõöùúûüýÿ.;^' --There are 130 characters in this text--

Set @RowCount = Rand()*100000 -- Set the amount of lines to be inserted --

While (@RowCount >=1)
Begin

   Insert Into RandomDataTable (CustomerID, SalesPersonID, Quantity, NumericValue, Today)
   Values(@RowCount, 
                 Concat(SubString(@Text, Abs(CheckSum(Rand()*130)%128)+2,2),SubString(@Text, Abs(CheckSum(Rand()*130)%126)-4,4),SubString(@Text,Abs(CheckSum(Rand()*130)%124)+2,4)),
                 Rand()*1000, 
	             Rand()*100+5, 
	             DATEADD(d, 1000*Rand() ,GetDate()))
  Set @RowCount = @RowCount - 1
End

Select ID, CustomerID, SalesPersonID, Quantity, NumericValue, Today 
From RandomDataTable
Go