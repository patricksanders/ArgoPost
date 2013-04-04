<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: UserInfomation.cfc
--->
<!--- this is the userID given to us from UI --->
<cfset UserID=#SESSION.UserID#>

<!---Adds a Subscription to the list of the user's subscripitons. --->
<cffunction name="AddToSubscriptons" returntype="void">
<cfargument name="Thread" type="int">

<cfquery name="Add" datasource="#SEproject_argopost#"> 
INSERT into Subscriptions
values(MAX(SubscriptionID)+1,#UserID#,@Thread);
</cfquery>

</cffunction>
<!---Removes a Subscription to the list of the user's subscripitons. --->
<cffunction name="removefromSubscriptions" returntype="void">
<cfargument name="Thread" type="int">
<cfquery name="Delete" datasource="#SEproject_argopost#">
DELETE FROM Subscriptions
where ThreadID=@Thread
and userID=#UserID#;
</cfquery>
</cffunction>

</cfcomponent>