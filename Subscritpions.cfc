<cfcomponent output="false">
<cfquery name="addSubscriptions" datasource="#SEproject_argopost#">
select subcriptions
from Users
</cfquery>
<cfset subscrptionsofauser>
<!--- This Function will get the subscrptions that the user has. --->
<cffunction name="getSubcrptions" returntype="query">
<cfreturn subscrptionsofauser>
</cffunction>
</cfcomponent>