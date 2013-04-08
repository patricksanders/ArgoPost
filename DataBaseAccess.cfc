<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: DataBaseAccess.cfc
--->

<!--- This Query gets the list of Notifications from the database --->	
<cfquery name="dbget" datasource="#SEproject_argopost#">
Select * from Notification
</cfquery>

<cfset threadSubscribers>

<!--- This Function gets the list of Notifications from the database that is provided within the function.--->	
<cffunction name="getTable" returntype="query">
<cfreturn threadSubscribers>
</cffunction>

</cfcomponent>