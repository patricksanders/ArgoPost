<cfoutput>
<html>
<head>
<title>ArgoPost Search Test</title>
</head>
<body>
	<cftry>
		<cfinvoke component="ArgoPost" method="getArgoPostSearchResults" returnVariable="return">
			<cfinvokeargument name="s" value="test"> 		
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