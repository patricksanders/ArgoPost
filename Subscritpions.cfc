<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Subscritpions.cfc
--->

<!--- This query grabs the list of subcrpitons that the user has --->
<cfquery name="addSubscriptions" datasource="#SEproject_argopost#">
select subcriptions
from Users
where subcriptions=@subcriptions;
</cfquery>

<cfset subscrptionsofauser>
<!--- This Function will get the subscrptions that the user has. --->
<cffunction name="getSubcrptions" returntype="query">
<cfreturn subscrptionsofauser>
</cffunction>
</cfcomponent>