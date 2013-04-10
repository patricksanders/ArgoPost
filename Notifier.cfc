<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Notifier.cfc
--->

<cfset name="posterID"><!--- need to initialize from somewhere--->
<cfset threadID="threadID"><!---need to initialize from somewhere(UI?)--->
<cfset UWFID="UWFID">

<!--- This Query gets the IDs of the threads that are to be used for Notfication --->
<cfquery name="getIDs" datasource="SEproject_argopost">
	select * from subscriptions
	where ThreadID = <cfqueryparam value="#threadID#">; 
</cfquery>


<!--- This function sends an email to the list of people who are subscribed to a forum/thread --->
<cffunction name="sendTosubscribersofaCategory" returntype="void">
<cfloop index="count" list="#getIDs#">
<cfmail to="#email#" from="argopost@uwf.edu" subject="ArgoPost Notification">
#CreateEmailMessage#
</cfmail>
</cfloop>
</cffunction>

<!--- This function is the constructor of the Notifier Class --->
<cffunction name="Notifier" returntype="void">
<cfargument name="category" type="string">
#sendToSubscribersOfACategory()#
</cffunction>



<!--- This Function creates the email message that is sent to users of a thread that they 
are subscribed to when a new post is made. --->
<cffunction name="CreateEmailMessage" returntype="string">
	<cfargument name="UserID" type="numeric">
	
<!--- This query gets the email from the user for the Notifcation to be sent to.--->	
<cfquery name="email" datasource="SEproject_argopost">
	select Email from users
	where UserID = <cfqueryparam value="#UserID#">;
</cfquery>

<cfquery name="UserName" datasource="#SEproject_argopost#">
	select UWFID from Users
	where UserID = <cfqueryparam value="#UserID#">;
</cfquery>

<cfquery name="ThreadName" datasource="SEproject_argopost">
select Title from Threads
where ThreadID= <cfqueryparam value="#ThreadID#">;
</cfquery>

<!---query to get poster name--->
<cfquery name="UWFID"  datasource="SEproject_argopost">
select UWFID
from users
where userID= <cfqueryparam value="#UserID#">;
</cfquery>

<cfset message=
		Hello, #UWFID#
			You are recieving this message because a post was made in ArgoPost thread #Title#
			The user #PosterName# has posted in this thread.
			Navigate to <!--- url---> to check out the posts >
<cfreturn message>

</cffunction>
</cfcomponent>
