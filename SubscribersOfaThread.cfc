<cfcomponent output="false">
<cfquery name="dbgetIDs" datasource="#SEproject_argopost#">
SELECT Cast(UserID as Integer) FROM Notification;
</cfquery>
<cfquery name="dbgetThread" datasource="#SEproject_argopost#">
SELECT CAST(ThreadID as Integer) FROM Notification;
</cfquery>
<cfset ARGUMENTS.SubscriberOfAThread=dbgetIDs>
<cfset ARGUMENTS.ThreadID = dbgetThread>
</cfcomponent>