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
	
	<cfinvoke method="CheckForSubscriptions" returnVarible="Check">
	<cfinvokeargument name="ThreadID" value="#Arguments.ThreadID#">
	<cfinvokeargument name="currentUID"  value="#Arguments.UserID#">	
	</cfinvoke>
	<cfif Check eq true>
	
	<cfinvoke method="removefromSubscriptions">
	<cfinvokeargument name="ThreadID" value="#Arguments.ThreadID#">	
	</cfinvoke>
	
	<cfreturn true>
	<cfelse> 
	<cfcatch type="any">
			<cfreturn false>
		</cfcatch>
		</cftry>	
	 <cfreturn true>
	 </cfif>
</cffunction>

<cffunction name="CheckForSubscriptions" access="remote" returnType="boolean">
<cfargument name="ThreadID" requried="true">
<cfargument name="currentUID" required="true">
<cftry>
<cfquery name="CheckSubscriptions" datasource="ArgoPost_ArgoPost">
select UserID,ThreadID
from Notifications
where UserID = <cfqueryparam value="#Arguments.UserID#"  cfsqltype="cf_sql_numeric">
      ThreadID = <cfqueryparam value="#Arguments.ThreadID#"  cfsqltype="cf_sql_numeric">
having( Count(UserID) > 1)      
</cfquery>
<cfset subUID="#CheckSubscriptions.UserID#">
<cfset subTID="#CheckSubscriptions.ThreadID#"> 
<cfif ThreadID eq subTID>
<cfreturn true>
<cfelse>
<cfreturn false>	
</cfif>
<cfcatch type="any">
<cfreturn false>
</cfcatch>
</cftry>
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
			SELECT Threads.Title AS ThreadTitle, Threads.ThreadID  AS ThreadID, Forums.Title AS ForumTitle
			FROM Forums INNER JOIN (Threads INNER JOIN Notifications ON Threads.ThreadID = Notifications.ThreadID) 
			ON Forums.ForumID = Threads.ForumID
			WHERE Notifications.UserID = <cfqueryparam value="#userID#">;
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
	
	
	
</cfcomponent>
