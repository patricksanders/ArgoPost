<cfcomponent>

<cfset dataSource = "argoPost">
<!--- Mark expired method, which will also serve as the 'deletePost' function.  No posts will actually be deleted until the 'flushExpired' function is called.--->
<cffunction name="markExpired" access="remote" returnFormat="JSON" returnType="numeric">
		<cftry>
			<cfargument name="postID" type="numeric" required="true" >
			<cfset rtnValue = 0 >
			<cfset thisUserId = getUserName() >
			<cfset boolOkToDelete = false >
			<!--- Perform series of if/else statmenets to determine if the person attempting to remove the post owns it, or is faculty
				meaning they would have permission to remove it any way.--->
			<cfif getIsFaculty() >
				<cfset boolOkToDelete = true >
			<cfelse>
				<cfquery name="qGetUserId" datasource="DATASOURCENAME">
					select userID FROM Posts 
					WHERE postID = <cfqueryparam value="#arguments.postID#" cfsqltype="CF_SQL_INTEGER" >
				</cfquery>
				<cfif thisUserID EQ qGetUserId.userID >
					<cfset boolOkToDelete = true >
				<cfelse>
					<cfset rtnValue = 1 >
				</cfif>
			</cfif>
			
			<cfif boolOkToDelete >
				<cfquery name="qDeletePosts" datasource="DATASOURCENAME">
					update Posts
					set isExpired = false
					WHERE postID = <cfqueryparam value="#arguments.postID#" cfsqltype="CF_SQL_INTEGER" >
				</cfquery>
			</cfif>
			
		<cfcatch type="any">
			<cfset rtnValue = 10>
		</cfcatch>
		</cftry>
		<cfreturn rtnValue >
	</cffunction>


	<!--- Flush expired allows a faculty member to delete all expired posts from the database.  --->
	<cffunction name="flushExpired" access="remote" returnType="void">
			<!---  Verify that individual is actually a faculty member.--->
		<cfif #getIsFaculty()# = "1">
		<cfquery name="qDeletePosts" datasource="#dataSource#">
			DELETE FROM Posts WHERE IsExpired = '1';
		</cfquery>
		
		</cfif>
	</cffunction>



	<!---  This method runs every time a user logs in.  Right now the data base is missing a table that will be used in order to prevent the entire query from running
	more than once a day.--->
<cffunction name="checkExpired" access="remote" returnFormat="JSON" returnType="numeric">
		<cfquery name="qDeletePosts" datasource="DATASOURCENAME">
			update Posts
			set isExpired = true
			WHERE IsExpired <> true AND expirationDate < <cfqueryparam value="#dateFormat(now(),"mm/dd/yyyy")#" cfsqltype="CF_SQL_DATE" >
		</cfquery>
	</cffunction>
		
	




</cfcomponent>