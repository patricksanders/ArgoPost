
<html>
	<body>

	<!---cfset SESSION.UserID="4"--->
	<h2>getIDs('1')</h2>
	<cftry>
	<cfinvoke component="Notifier" method="getIDs" returnVariable="return">
	<cfinvokeargument name="t" value="1">
	</cfinvoke>
	<cfdump var="#return#">
	<cfcatch type="any">
		<h2>ERROR:</h2>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
				<!---<cfoutput><cfdump var="SESSION.UserID"></cfoutput--->
</body>
</html>