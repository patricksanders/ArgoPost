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
<cfloop list="#attributes.UserIDs#" index="item">
	<cfinvoke method="setEmail">
	<cfinvokeargument name="UserID" value="#item#">
	</cfinvoke>
	<cfinvoke method="CreateEmailMessage" returnvariable="message">
	<cfmail to="#attributes.email#" from="seproject@uwf.edu" subject="ArgoPost Notification" username="seproject@uwf.edu" password="tuuRu9A">
#message#</cfmail>
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
	select Email from Users
	where UserID = <cfqueryparam value="#arguments.UserID#">;
</cfquery>
<cfset attributes.email="#getEmail.Email#">
</cffunction>

<!--- This Function creates the email message that is sent to users of a thread that they 
are subscribed to when a new post is made. --->
<cffunction name="CreateEmailMessage" returntype="string">
<cfset br="#chr(13)##chr(10)#">
<cfset message="Hello, ArgoPost User, #br#
You are recieving this message because a post was made in an ArgoPost thread you are subscribed to. #br#
Navigate to uwf.edu/ArgoPost to check out the post!" >
<cfreturn message>
</cffunction>
</cfcomponent>


