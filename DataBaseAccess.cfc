<cfcomponent output="false">
<cfquery name="dbget" datasource="#SEproject_argopost#">
Select * from Notification

</cfquery>

<cfset threadSubscribers>
<cffunction name="getTable" returntype="query">
<cfreturn threadSubscribers>
</cffunction>
</cfcomponent>