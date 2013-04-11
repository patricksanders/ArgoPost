<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Subscriber.cfc
--->
<cfset arguments =
	{userName = "#Session.userName#"}>

<cfinvoke
	argumentCollection="#arguments#"
	component="Post"
	Method="getUserID"
	userName="#Session.userName#"
	returnVariable ="userIDnum">
	
<cfset userID = #userIDnum#>
<!---Adds a Subscription to the list of the user's subscripitons. --->
<cffunction name="AddToSubscriptions" returntype="boolean">
	<cfargument name="ThreadID" type="int">
	
	<cftry>
	<cfquery name="Add" datasource="SEproject_argopost"> 
			INSERT into Subscriptions(UserID,ThreadID)
			values(<cfqueryparam value="#userID#">,
					<cfqueryparam value="#Arguments.ThreadID#">);
	</cfquery>
	<cfcatch type="any">
			<cfreturn false>
		</cfcatch>
		</cftry>
	<cfreturn true>
</cffunction>
<!---Removes a Subscription to the list of the user's subscripitons. --->
<cffunction name="removefromSubscriptions" returntype="void">
	<cfargument name="ThreadID" type="int">
	<cfquery name="Delete" datasource="SEproject_argopost">
		DELETE FROM Subscriptions
		where ThreadID = <cfqueryparam value="#Arguments.ThreadID#">
		and UserID = <cfqueryparam value="#userID#">;
	</cfquery>
</cffunction>

<!--- Gets a JSON object representing the Forums in ArgoPost --->
	<cffunction name="getSubs" access="remote" returnFormat="JSON" returnType="struct">	
		<cfset rtnStruct = structNew()>
		<cftry>
			<cfquery name="getArgoPostSubs" datasource="SEproject_argopost">
			select *
			from Notifications
			where UserID = <cfqueryparam value="#userID#">;
		</cfquery>
		<cfcatch type="any">
			<cfreturn rtnStruct>
		</cfcatch>
		</cftry>
		<cfset i = 0>
		<cfloop query="getArgoPostSubs">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfloop list="#getArgoPostSubs.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn) >
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>

</cfcomponent>