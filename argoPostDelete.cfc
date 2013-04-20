<cfcomponent>
	<cfset dataSource = "seproject_argopost">
	
	<!--- Mark expired method, which will also serve as the 'deletePost' function.  No posts will actually be deleted until the 'flushExpired' function is called.--->
	<cffunction name="deleteArgoPost" access="remote" returnFormat="JSON" returnType="struct">
			<cfargument name="postId" type="numeric" required="true">
			<cfargument name="threadId" type="numeric" required="true">
			<cfset rtnValue = structNew()>
			<cfset rtnValue["threadId"] = #arguments.threadId#>
			<cfset thisUserId = #session.userName#>
			<cfset boolOkToDelete = false >
			<cftry>
				
				<!--- Perform series of if/else statmenets to determine if the person attempting to remove the post owns it, or is faculty
					meaning they would have permission to remove it any way.--->
				<cfif #session.isFaculty#>
					<cfset boolOkToDelete = true >
				<cfelse>
					<cfquery name="qGetUserId" datasource="#dataSource#">
						select u.UWFID as Uwf_Id
						from Posts as p
						inner join Users as u on u.UserID = p.UserID
						where postID = <cfqueryparam value="#arguments.postId#" cfsqltype="CF_SQL_INTEGER" >
					</cfquery>
					
					<!--- forcing the component to return the uwf ID that is currently sees --->
					<cfset rtnValue["deleteSuccess"] = qGetUserId.Uwf_Id;
					<cfreturn rtnValue>
					
					<cfif thisUserID EQ qGetUserId.Uwf_Id>
						<cfset boolOkToDelete = true >
					<cfelse>
						<cfset rtnValue["deleteSuccess"] = 0>
					</cfif>
				</cfif>
				<cfif boolOkToDelete>
					<cfquery name="qDeletePosts" datasource="#dataSource#">
						delete from Posts
						where postID = <cfqueryparam value="#arguments.postId#" cfsqltype="CF_SQL_INTEGER" >
					</cfquery>
					<cfset rtnValue["deleteSuccess"] = 1>
				</cfif>
			<cfcatch type="any">
				<cfset rtnValue["deleteSuccess"] = -1>
			</cfcatch>
			</cftry>
			<cfreturn rtnValue>
	</cffunction>
	
	<!--- Flush expired allows a faculty member to delete all expired posts from the database.  --->
	<cffunction name="flushExpired" access="remote" returnType="void">
			<!---  Verify that individual is actually a faculty member.--->
		<cfif #session.isFaculty# EQ 1>
		<cfquery name="qDeletePosts" datasource="#dataSource#">
			DELETE FROM Posts WHERE IsExpired = '1';
		</cfquery>
		</cfif>
	</cffunction>
	
	<!---  This method runs every time a user logs in.  Right now the data base is missing a table that will be used in order to prevent the entire query from running
	more than once a day.--->
	<cffunction name="checkExpired" access="remote" returnFormat="JSON" returnType="numeric">
		<cfquery name="qDeletePosts" datasource="#dataSource#">
			update Posts
			set isExpired = true
			WHERE IsExpired <> true AND expirationDate < <cfqueryparam value="#dateFormat(now(),"mm/dd/yyyy")#" cfsqltype="CF_SQL_DATE" >
		</cfquery>
	</cffunction>
</cfcomponent>