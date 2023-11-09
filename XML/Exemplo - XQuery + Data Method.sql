--uses the query() and data() methods

DECLARE @SampleXML XML
SET @SampleXML = '
<root>
	<L1>
		<L2>This is the First Line</L2>
	</L1>
	<L1>
		<L2>This is the Second Line</L2>
	</L1>
</root>'
SELECT @SampleXML.query('data(/root/L1[L2 = "This is the Second Line"])')
