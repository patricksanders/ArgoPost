<cfoutput>
<html>
<head>
<title>ArgoPost Search Test</title>
</head>
<body>
	<h2>checkSession()</h2>
	<cftry>
		<cfinvoke component="ArgoPost" method="checkSession" returnVariable="return">	
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