ALTER TRIGGER [dbo].[Invoice_Line_Temp_Insert]

on [dbo].[Invoice_Line_Temp]

for Insert

As

BEGIN

 

UPDATE il

SET Item_Desc = i.Item_Desc,

Invoice_Date = i.Invoice_Date,

Group_Number = i.Group_Number,

Item_Code = i.Item_Code,

Quantity_Sold = i.Quantity_Sold,

Section_Number = i.Section_Number,

LastUpdate = i.LastUpdate

FROM dbo.invoice_line il

INNER JOIN inserted

ON il.transaction_id = i.Transaction_id

AND il.Line_Number = i.Line_Number

 

INSERT INTO dbo.Invoice_Line

(InvoiceLineId,Transaction_ID,Line_Number,Item_Desc,Invoice_Date,

Group_Number,Item_Code,Quantity_Sold,Section_Number,LastUpdate)

SELECT newid(), i.Transaction_id, i.Line_number, i.Item_Desc, i.Invoice_Date,

i.GroupNumber, i.Item_Code, i.Quantity_Sold, i.Section_Number, i.LastUpdate

FROM inserted

WHERE NOT EXISTS

( SELECT * FROM dbo.Invoice_Line il

WHERE il.transaction_id = i.Transaction_id

AND il.Line_Number = i.Line_Number)

END