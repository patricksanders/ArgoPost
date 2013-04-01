<cfoutput>
<html>
<head>
<title>Web Service Call and Dump</title>
</head>
<body>
	<cftry>
		<cfinvoke webservice="http://dev.argopost.com/ArgoPost.cfc?wsdl" method="getSearchResults" returnVariable="return">
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