<cfcomponent>	
	
	<!--- This name was used for testing purposes. It will need to be changed in the to the name of the database we are 
	officially using --->
	<cfset dataSource = "argoPost"> 
	
	<cffunction name="addPost" access="remote"  returnType="boolean" returnFormat="JSON">
		<cfargument name="postTitle"  required="true" />
		<cfargument name="postContent" required="true" />
		<cfargument name="threadID" required="true" />		
		
		<!--- Get all the dates needed for the post --->
		<cfset postDate = Now()>
		<cfset postDate = DateFormat(postDate, "mm/dd/yyyy")>
		<cfset dateLastModified = Now()>
		<cfset dateLastModified = DateFormat(dateLastModified, "mm/dd/yyyy")>
		<cfset expDate = Now() + 30>
		<cfset expDate = DateFormat(expDate, "mm/dd/yyyy")>
		
		<cfset currentUID = getUserID(#session.userName#)>
		
		<cftry>
			<!--- Add the post to the database--->
			<cfquery name="addPostQuery" datasource="#dataSource#" >		
				insert into Posts (UserID, ThreadID, LastModifiedDate, EnteredDate, ExpirationDate, Title, Description)
				values(<cfqueryparam value="#currentUID#" cfsqltype="cf_sql_numeric">,
				  	   <cfqueryparam value="#arguments.threadID#" cfsqltype="cf_sql_numeric">,
				 	   <cfqueryparam value="#dateLastModified#" cfsqltype="cf_sql_date">,
				 	   <cfqueryparam value="#postDate#" cfsqltype="cf_sql_date">,
				  	   <cfqueryparam value="#expDate#" cfsqltype="cf_sql_date">,
				 	   <cfqueryparam value="#arguments.postTitle#" cfsqltype="cf_sql_varchar">,
				 	   <cfqueryparam value="#arguments.postContent#" cfsqltype="cf_sql_varchar">)			
			</cfquery>
		<cfcatch type="any">
			<cfreturn false>
		</cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>
	
	<!--- This function is used to query the Users table for a UserID so that it can be stored in the database with 
	the post that they have created. --->
	<cffunction name="getUserID" access="remote" returnType="Numeric">
		<cfargument name="userName" required="true" />
		<cfquery name="getUID" dataSource="#dataSource#" result="r">
			select *
			from Users
			where UWFID = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset uID="#getUID.UserID#">
		<cfreturn "#uID#">
	</cffunction>
	
	<!--- This function queries the db for the threadID to be added to this post --->
	<cffunction name="getThreadID" access="remote" returnType="Numeric">
		<cfargument name="threadTitle" required="true">		
		<!--- The query for the threadID should go here and then returned --->
		<cfquery name="threadIDquery" datasource="#dataSource#" result="tID">
			select *
			from Threads
			where Title = <cfqueryparam value="#arguments.threadTitle#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset threadID="#threadIDquery.ThreadID#">
		<cfreturn "#threadID#">
	</cffunction>
	
	<cffunction name="checkIfLoggedIn" access="remote" returnType="boolean" returnFormat="JSON">
		<cfif session.loggedIn eq 0>
			<cfreturn false >
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<!--- Gets a JSON object representing the Forums in ArgoPost --->
	<cffunction name="getForums" access="remote" returnFormat="JSON" returnType="struct">	
		<cfset rtnStruct = structNew()>
		<cftry>
			<cfquery name="getArgoPostForums" datasource="#dataSource#">
			select ForumID, Title
			from Forums;
		</cfquery>
		<cfcatch type="any">
			<cfreturn rtnStruct>
		</cfcatch>
		</cftry>
		<cfset i = 0>
		<cfloop query="getArgoPostForums">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfloop list="#getArgoPostForums.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn) >
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>
	
	<!--- Gets a JSON object representing the Threads in ArgoPost --->
	<cffunction name="getThreads" access="remote" returnFormat="JSON" returnType="struct">
		<cfargument name="forumID" required="true">	
		<cfset rtnStruct = structNew()>
		<cftry>
			<cfquery name="getArgoPostThreads" datasource="#dataSource#">
			select ThreadID, Title
			from Threads
			where ForumID = <cfqueryparam value="#arguments.forumID#" cfsqltype="cf_sql_integer">;
		</cfquery>
		<cfcatch type="any">
			<cfreturn rtnStruct>
		</cfcatch>
		</cftry>
		<cfset i = 0>
		<cfloop query="getArgoPostThreads">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfloop list="#getArgoPostThreads.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn) >
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>
	
</cfcomponent>
