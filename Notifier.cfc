<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Notifier.cfc
--->

<!--- This function is the constructor of the Notifier Class --->
<cffunction name="Notifier" returntype="void">
<cfargument name="threadID" type="numeric" required="true">
<cfinvoke method="sendToSubscribersOfACategory">
<cfinvokeargument name="threadID" value="#Arguments.threadID#">
</cfinvoke>
</cffunction>

<!--- This function sends an email to the list of people who are subscribed to a thread --->
<cffunction name="sendTosubscribersofaCategory" returntype="void" access="remote">
	<cfargument name="threadID">

<cfinvoke method="setIDS">
<cfinvokeargument name="threadID" value="#Arguments.threadID#">
</cfinvoke>
<cfinvoke method="getTitles">
<cfinvokeargument name="threadID" value="#Arguments.threadID#">
</cfinvoke> 
<cfloop list="#attributes.UserIDs#" index="item">
	<cfinvoke method="setEmail">
	<cfinvokeargument name="UserID" value="#item#">
	</cfinvoke>
	<cfinvoke method="CreateEmailMessage" returnvariable="message">
	<cfmail to="#attributes.email#" from="seproject@uwf.edu" subject="ArgoPost Notification" username="argopost@uwf.edu" password="hurried296!waves">
#message#</cfmail>
</cfloop>
</cffunction>

<cffunction name="setIDs" access="remote">
	<cfargument name="threadID" required="true">
<!--- This Query gets the IDs of the user that are subscribed to a thread--->	
<cfquery name="getIDs" datasource="ArgoPost_ArgoPost">
	select * 
	from Notifications
	where ThreadID = <cfqueryparam value="#arguments.threadID#">; 
</cfquery>

<cfset attributes.userIDs=ArrayToList(getIDs["UserID"], ",")><!---gets list of userIDs based on the threadID--->
</cffunction>

<!---this function sets the email address based on the userID--->
<cffunction name="setEmail" access="remote">
	<cfargument name ="UserID" required="true">
	<cfquery name="getEmail" datasource="ArgoPost_ArgoPost">
	select Email from Users
	where UserID = <cfqueryparam value="#arguments.UserID#">;
</cfquery>
<cfset attributes.email="#getEmail.Email#">
</cffunction>

<!--- This Function gets the The Title of the Thread and the Forum that the new post in created within --->
<cffunction name="getTitles" access="remote">
	<cfargument name = "threadID" required="true">
	<cfquery name="getTitles" datasource="ArgoPost_ArgoPost">
	select t.Title as Thread_Title,
	       t.ForumID as Thread_ForumID,
	       f.ForumID as Forum_ForumID,
	       f.Title as Forums_Title
	from Threads as t
	inner join Forums as f
	on f.ForumID = t.ForumID 
	where ThreadID = <cfqueryparam value="#arguments.threadID#">;
	</cfquery>
<cfset attributes.threadTitle="#getTitles.t.Title#">
<cfset attributes.forumTitle="#getTitles.f.Title#">
</cffunction>

<!--- This Function creates the email message that is sent to users of a thread that they 
are subscribed to when a new post is made. --->
<cffunction name="CreateEmailMessage" returntype="string">
<cfset br="#chr(13)##chr(10)#">
<cfset message="Hello ArgoPost User, #br#
You are recieving this message because a post was made in the ArgoPost thread " + #attributes.threadTitle# + 
"that you are subscribed to under the forum: " + #attributes.forumTitle# + ". #br#
Navigate to uwf.edu/seproject/ArgoPost to check out the post!" >
<cfreturn message>
</cffunction>
</cfcomponent>


