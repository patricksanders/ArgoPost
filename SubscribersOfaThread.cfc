<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: SubscribersofaThread.cfc
--->
<!--- This Query gets the List of user IDs from the database. --->	
<cfquery name="dbgetIDs" datasource="#SEproject_argopost#">
SELECT Cast(UserID as Integer) FROM Notification;
</cfquery>

<!--- This Query gets the List of user IDs from the database. --->
<cfquery name="dbgetThread" datasource="#SEproject_argopost#">	
SELECT CAST(ThreadID as Integer) FROM Notification;
</cfquery>

<cfset ARGUMENTS.SubscriberOfAThread=dbgetIDs>
<cfset ARGUMENTS.ThreadID = dbgetThread>
</cfcomponent>