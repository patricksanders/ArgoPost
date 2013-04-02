<cfoutput>
<html>
<head>
<title>Web Service Call and Dump</title>
</head>
<body>
	<cftry>
		<cfinvoke  
    		webservice="argopost.cfc?wsdl" 
    		method="getSearchResults"
    		returnvariable="return"> 
		<cfinvokeargument name="s" value="work"/> 
		</cfinvoke> 
		<cfdump var="#return#">
	<cfcatch type="any">
		<h2>ERROR:</h2>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
</body>
</html>
</cfoutput>