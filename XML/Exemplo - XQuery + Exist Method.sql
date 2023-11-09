-- uses exist() method

DECLARE @SampleXML XML, @Exists bit

SET @SampleXML = '
<root>
	<L1>
		<L2>This is the First Line</L2>
	</L1>
	<L1>
		<L2>This is the Second Line</L2>
	</L1>
</root>'
SET @Exists = @SampleXML.exist('/root/L1/L2[text() = 
    "This is the First Line"]')

SELECT @Exists




