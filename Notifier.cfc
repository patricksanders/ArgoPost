<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Notifier.cfc
--->

<cfset name="posterID"><!--- need to initialize from somewhere--->
<cfset threadID="threadID"=><!---need to initialize from somewhere(UI?)--->

<!--- This Query gets the IDs of the threads that are to be used for Notfication --->
<cfquery name="getIDs" datasource="#SEproject_argopost#">
	select * from subscriptions
	where threadID=@threadID; 
</cfquery>

<!--- This function sends an email to the list of people who are subscribed to a forum/thread --->
<cffunction name="sendTosubscribersofaCategory" returntype="void">
<cfloop index="count" list="#getIDs#">
<cfmail to="#email#" from="argopost@uwf.edu" subject="ArgoPost Notification">
#CreateEmailMessage#
</cfmail>
</cfloop>
</cffunction>

<!--- This Function is the constructor of the Notifier Class --->
<cffunction name="Notifier" returntype="void">
<cfargument name="category" type="string">
#sendToSubscribersOfACategory()#
</cffunction>

<!--- This query gets the email from the user for the Notifcation to be sent to.--->
<cfquery name="email" datasource="#SEproject_argopost#">
	select Email from users
	where UserID = @UserID;
</cfquery>

<!--- This Function creates the email message that is sent to users of a thread that they 
are subscribed to when a new post is made. --->
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
