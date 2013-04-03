<cfcomponent output="false">
<cfset name="posterID"><!--- need to initialize from somewhere--->
<cfset threadID="threadID"=><!---need to initialize from somewhere(UI?)--->
<cfquery name="getIDs" datasource="#SEproject_argopost#">
	select * from subscriptions
	where threadID=@threadID; 
</cfquery>
<cffunction name="sendTosubscribersofaCategory" returntype="void">
<cfloop index="count" list="#getIDs#">
<cfmail to="#email#" from="argopost@uwf.edu" subject="ArgoPost Notification">
#CreateEmailMessage#
</cfmail>
</cfloop>
</cffunction>

<cffunction name="Notifier" returntype="void">
<cfargument name="category" type="string">
#sendToSubscribersOfACategory()#
</cffunction>
<cfquery name="email" datasource="#SEproject_argopost#">
	select Email from users
	where UserID = @UserID;
</cfquery>
<cffunction name="CreateEmailMessage" returntype="string">
	<cfargument name="UserID" type="numeric">
<cfquery name="UserName" datasource="#APPLICATION.datasource#">
	select name from Users
	where UserID = #UserID#;
</cfquery>
<cfquery name="ThreadName" datasource="APPLICATION.datasource">
select Title from Threads
where ThreadID=#threadID#;
</cfquery>
<!---query to get poster name--->
<cfquery name="UWFID"  datasource="APPLICATION.datasource">
select UWFID
from users
where userID= @userID;
</cfquery>
<cfset message=
		Hello, #UWFID#
			You are recieving this message because a post was made in ArgoPost thread #Title#
			The user #PosterName# has posted in this thread.
			Navigate to <!--- url---> to check out the post!>s
<cfreturn message>
</cffunction>
</cfcomponent>