<cfcomponent output="false">
<!--this is the userID given to us from UI-->
<cfset UserID=#SESSION.UserID#>

<cffunction name="AddToSubscriptons" returntype="void">
<cfargument name="Thread" type="int">
<cfquery name="Add" datasource="#SEproject_argopost#"> 
INSERT into Subscriptions
values(MAX(SubscriptionID)+1,#UserID#,@Thread);
</cfquery>
</cffunction>

<cffunction name="removefromSubscriptions" returntype="void">
<cfargument name="Thread" type="int">
<cfquery name="Delete" datasource="#SEproject_argopost#">
DELETE FROM Subscriptions
where ThreadID=@Thread
and userID=#UserID#;
</cfquery>
</cffunction>

</cfcomponent>