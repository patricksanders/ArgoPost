<html>
<body>

	<!---cfset SESSION.UserID="4"--->
	<h2>addSubscription('1')</h2>
	<cftry>
	<cfinvoke component="Subscriber" method="CheckForSubscriptions" returnVariable="test">
	<cfinvokeargument name="threadID" value="1">
	<cfinvokeargument name="userID" value="2">
	</cfinvoke>
	<cfdump var="#test#">
	<!--- <cfdump var="#return#"> --->
	<cfcatch type="any">
		<h2>ERROR:</h2>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
				<!---<cfoutput><cfdump var="SESSION.UserID"></cfoutput--->
</body>
</html>
