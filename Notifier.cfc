<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Notifier.cfc
--->

<!--- This function is the constructor of the Notifier Class --->
<cffunction name="Notifier" returntype="void">
<cfargument name="ThreadID" type="numeric" required="true">
#sendToSubscribersOfACategory(#Arguments.ThreadID#)#
</cffunction>

<!--- This function sends an email to the list of people who are subscribed to a thread --->
<cffunction name="sendTosubscribersofaCategory" returntype="void">
	<cfargument name="threadID">
#setIDs(#Arguments.threadID#)#
<cfset item>
<cfloop list="#attributes.userIDs#" index="item">
	#setEmail(#item##)#
	<cfmail to="#attributes.email#" from="seproject@uwf.edu" subject="ArgoPost Notification">
#CreateEmailMessage()#</cfmail>
</cfloop>
</cffunction>

<cffunction name="setIDs" access="remote">
	<cfargument name="threadID" required="true">
<!--- This Query gets the IDs of the user that are subscribed to a thread--->	
<cfquery name="getIDs" datasource="SEproject_argopost">
	select * 
	from subscriptions
	where ThreadID = <cfqueryparam value="#arguments.threadID#">; 
</cfquery>

<cfset attributes.userIDs=ArrayToList(getIDs["UserID"], ",")><!---gets list of userIDs based on the threadID--->
</cffunction>

<!---this function sets the email address based on the userID--->
<cffunction name="setEmail" access="remote">
	<cfargument name ="UserID" required="true">
	<cfquery name="getEmail" datasource="SEproject_argopost">
	select Email from users
	where UserID = <cfqueryparam value="#arguments.UserID#">;
</cfquery>
<cfset attributes.email="#getEmail#">
</cffunction>

<!--- This Function creates the email message that is sent to users of a thread that they 
are subscribed to when a new post is made. --->
<cffunction name="CreateEmailMessage" returntype="string">
<cfset message="Hello, ArgoPost User, 
You are recieving this message because a post was made in an ArgoPost thread you are subscribed to.
Navigate to uwf.edu/ArgoPost to check out the post!" >
<cfreturn message>
</cffunction>
</cfcomponent>


