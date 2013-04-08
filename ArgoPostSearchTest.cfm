<cfoutput>
<html>
<head>
<title>ArgoPost Search Test</title>
</head>
<body>
	<h2>getArgoPostSearchResults('test')</h2>
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
	<h2>getArgoPostForums()</h2>
	<cftry>
		<cfinvoke component="ArgoPost" method="getArgoPostForums" returnVariable="return">		
		</cfinvoke>
		<cfdump var="#return#">
	<cfcatch type="any">
		<h2>ERROR:</h2>
		<cfdump var="#cfcatch#">
	</cfcatch>
	
	</cftry>
	<h2>getArgoPostThreads(1)</h2>
	<cftry>
		<cfinvoke component="ArgoPost" method="getArgoPostThreads" returnVariable="return">
			<cfinvokeargument name="f" value="1">		
		</cfinvoke>
		<cfdump var="#return#">
	<cfcatch type="any">
		<h2>ERROR:</h2>
		<cfdump var="#cfcatch#">
	</cfcatch>
	
	</cftry>
	<h2>getArgoPostPosts(1)</h2>
	<cftry>
		<cfinvoke component="ArgoPost" method="getArgoPostPosts" returnVariable="return">
			<cfinvokeargument name="t" value="1">		
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