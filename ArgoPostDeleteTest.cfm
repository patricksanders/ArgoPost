<cfoutput>
<html>
<head>
<title>ArgoPost Search Test</title>
</head>
<body>
	<h2>markExpired('test')</h2>
	<cftry>
		<cfinvoke component="argoPostDelete" method="markExpired" returnVariable="return">
			<cfinvokeargument name="postID" value="1"> 		
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