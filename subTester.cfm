<html>
  <body>

	<!---cfset SESSION.UserID="4"--->
	<h2>getTitle('1')</h2>
	<cftry>
	<cfinvoke component="Notifier" method="Notifier">
	<cfinvokeargument name="threadID" value="1">
	</cfinvoke>
	<!--- <cfdump var="#return#"> --->
	<cfcatch type="any">
		<h2>ERROR:</h2>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
				<!---<cfoutput><cfdump var="SESSION.UserID"></cfoutput--->
</body>
</html>
