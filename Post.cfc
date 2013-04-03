<cfcomponent>	
	
	<!--- This name was used for testing purposes. It will need to be changed in the to the name of the database we are 
	officially using --->
	<cfset dataSource = "SEproject_argopost"> 
	
	<cffunction name="addPost" access="remote"  returnType="boolean" returnFormat="JSON">
		<cfargument name="postTitle"  required="true" />
		<cfargument name="postContent" required="true" />
		<cfargument name="threadTitle" required="true" />		
		
		<!--- Get all the dates needed for the post --->
		<cfset postDate = Now()>
		<cfset postDate = DateFormat(postDate, "mm/dd/yyyy")>
		<cfset dateLastModified = Now()>
		<cfset dateLastModified = DateFormat(dateLastModified, "mm/dd/yyyy")>
		<cfset expDate = Now() + 30>
		<cfset expDate = DateFormat(expDate, "mm/dd/yyyy")>
		
		<!--- Get the argonet username of the current user and query the db for the UserID of this user
		<cfinvoke component="User" method="getUserName" returnvariable="currentUserName">
		</cfinvoke>		
		<cfset currentUID = "#currentUserName#">
		 --->
		
		<cfset currentUID = getUserID(#session.userName#)>
		
		<!--- Get the thread ID of this thread --->
		<cfset threadID = getThreadID("#arguments.threadTitle#")>
		
		<!--- Add the post to the database--->
		<cfquery name="addPostQuery" datasource="#dataSource#" >		
			insert into Posts (UserID, ThreadID, LastModifiedDate, EnteredDate, ExpirationDate, Title, Description)
			values('#currentUID#', '#threadID#', '#dateLastModified#', '#postDate#', '#expDate#', '#arguments.postTitle#', '#arguments.postContent#');			
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<!--- This function is used to query the Users table for a UserID so that it can be stored in the database with 
	the post that they have created. --->
	<cffunction name="getUserID" access="remote" returnType="Numeric">
		<cfargument name="userName" required="true" />
		<cfquery name="getUID" dataSource="#dataSource#" result="r">
			select *
			from Users
			where UWFID = '#arguments.userName#';
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
			where Title = '#arguments.threadTitle#';
		</cfquery>
		
		<cfset threadID="#threadIDquery.ThreadID#">
		<cfreturn "#threadID#">
	</cffunction>
	
</cfcomponent>
