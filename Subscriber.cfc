<cfcomponent output="false">
<!---
Subscription and Notification Team Implemention Artifact
Team Members: Christopher Marco, Matthew Neau, Phillp Byram
Filename: Subscriber.cfc
--->
<cfset arguments =
	{userName = "#Session.userName#"}>

<cfinvoke
	argumentCollection="#arguments#"
	component="Post"
	Method="getUserID"
	userName="#Session.userName#"
	returnVariable ="userIDnum">
	
<cfset userID = #userIDnum#>
<!---Adds a Subscription to the list of the user's subscripitons. --->
<cffunction name="AddToSubscriptions" access="remote" returntype="boolean">

	<cfargument name="ThreadID" type="int">
	<cfset currentUID = getUserID(#session.userName#)>
	
	<cftry>
	<cfquery name="Add" datasource="ArgoPost_ArgoPost"> 
			insert into Notifications(UserID,ThreadID)
			values(<cfqueryparam value="#currentUID#"  cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Arguments.ThreadID#"  cfsqltype="cf_sql_numeric">);
	</cfquery>
	<cfcatch type="any">
			<cfreturn false>
		</cfcatch>
		</cftry>
	<cfreturn true>
</cffunction>



<!---Removes a Subscription to the list of the user's subscripitons. --->
<cffunction name="removefromSubscriptions" access="remote" returntype="void">

	<cfargument name="ThreadID" type="int">
	<cfset currentUID = getUserID(#session.userName#)>

	<cfquery name="Delete" datasource="ArgoPost_ArgoPost">
		DELETE FROM Notifications
		where ThreadID = <cfqueryparam value="#Arguments.ThreadID#">
		and UserID = <cfqueryparam value="#currentUID#" cfsqltype="cf_sql_numeric">;
	</cfquery>
</cffunction>

<!--- This function is used to query the Users table for a UserID so that it can be stored in the database with 
	the post that they have created. --->
	<cffunction name="getUserID" access="remote" returnType="Numeric">
		<cfargument name="userName" required="true" />
		<cfquery name="getUID" dataSource="ArgoPost_ArgoPost" result="r">
			select *
			from Users
			where UWFID = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset uID="#getUID.UserID#">
		<cfreturn "#uID#">
	</cffunction>




<!--- Gets a JSON object representing the Forums in ArgoPost --->
	<cffunction name="getSubs" access="remote" returnFormat="JSON" returnType="struct">	
		<cfset rtnStruct = structNew()>
		<cftry>
			<cfquery name="getArgoPostSubs" datasource="ArgoPost_ArgoPost">
			SELECT Threads.Title, Threads.ThreadID, Forums.Title AS Forum_Title
			FROM Forums INNER JOIN (Threads INNER JOIN Subscriptions ON Threads.ThreadID = Subscriptions.ThreadID) 
			ON Forums.ForumID = Threads.ForumID
			WHERE (((Subscriptions.UserID)=<cfqueryparam value="#userID#">));
		</cfquery>
		<cfcatch type="any">
			<cfreturn rtnStruct>
		</cfcatch>
		</cftry>
		<cfset i = 0>
		<cfloop query="getArgoPostSubs">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfloop list="#getArgoPostSubs.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn) >
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
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
<cfset attributes.threadTitle="#getTitles.Thread_Title#">
<cfset attributes.forumTitle="#getTitles.Forums_Title#">
</cffunction>
	
</cfcomponent>
