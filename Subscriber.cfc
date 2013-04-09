<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Subscriber.cfc
--->
<cfinvoke component="Post" Method="getUserID" arg1="Session.userName" returnVariable ="userIDnum">
<cfset userID = #userIDnum#>
<!---Adds a Subscription to the list of the user's subscripitons. --->
<cffunction name="AddToSubscriptions" returntype="void">
	<cfargument name="ThreadID" type="int">
	
	<cfquery name="Add" datasource="SEproject_argopost"> 
			INSERT into Subscriptions
			values(	MAX(SubscriptionID)+1,
					<cfqueryparam value="#userID#">,
					<cfqueryparam value="Arguments.ThreadID">);
	</cfquery>
</cffunction>
<!---Removes a Subscription to the list of the user's subscripitons. --->
<cffunction name="removefromSubscriptions" returntype="void">
	<cfargument name="ThreadID" type="int">
	<cfquery name="Delete" datasource="SEproject_argopost">
		DELETE FROM Subscriptions
		where <cfqueryparam value="Arguments.ThreadID">
		and <cfqueryparam value="#userID#">;
	</cfquery>
</cffunction>
</cfcomponent>