Declare @X XML

Set @X = '<X value="one" />
                 <X value="01" />
                 <X value="001" />'

Select @X

select @X.value('min(/X/@value)', 'varchar(10)');