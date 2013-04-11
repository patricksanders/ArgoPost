<cfcomponent>
	<!--- The name of the Cold Fusion datasource --->
	<cfset theDS="seproject_argopost">

	<!--- Gets a JSON object representing Posts in the ArgoPost system --->
	<cffunction name="getArgoPostSearchResults" access="remote" returnFormat="JSON" returnType="struct">	
		<cfargument name="s" >
		<cfset rtnStruct = structNew()>
		<cfif len(trim(#arguments.s#))>
			<cftry>
			<cfquery name="getArgoPostSearchResults" datasource="#theDS#">
				select 	p.PostID as Post_ID
						, p.Title as Post_Title
						, p.Description as Post_Description
						, p.EnteredDate as Post_EnteredDate
            			, p.ExpirationDate as Post_ExpirationDate
            			, p.LastModifiedDate as Post_LastModifiedDate
            			, u.UWFID as Uwf_Id
						, t.ThreadID as Thread_ID
						, t.Title as Thread_Title
						, f.ForumID as Forum_ID
						, f.Title as Forum_Title
				from ((Posts as p 
				inner join Threads as t on t.ThreadID = p.ThreadID)
				inner join Forums as f on f.ForumID = t.ForumID)
				inner join Users as u on u.UserID = p.UserID
				where (LCase(p.Title) like LCase(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LCase(p.Description) like LCase(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LCase(t.Title) like LCase(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LCase(f.Title) like LCase(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LCase(u.UWFID) like LCase(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">))
				and IsExpired = 0
				order by p.EnteredDate desc;
			</cfquery>
			<cfcatch type="any">
				<cfset rtnStruct["ERROR"] = "There was an error executing the query.">
				<cfset rtnStruct["MESSAGE"] = #cfcatch#>
				<cfreturn rtnStruct>
			</cfcatch>
			</cftry>
		<cfelse> 
			<cfreturn rtnStruct>
		</cfif>
		<cfset i = 0>
		<cfloop query="getArgoPostSearchResults">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfset rtnStruct[i]["IS_FACULTY"] = #session.isFaculty#>
			<cfset rtnStruct[i]["LOGGED_IN_USER"] = #session.userName#>
			<cfloop list="#getArgoPostSearchResults.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn)>
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>
	
	<!--- Gets a JSON object representing the Forums in ArgoPost --->
	<cffunction name="getArgoPostForums" access="remote" returnFormat="JSON" returnType="struct">	
		<cfset rtnStruct = structNew()>
		<cftry>
			<cfquery name="getArgoPostForums" datasource="#theDS#">
			select 	f.ForumID as Forum_ID
					, f.Title as Forum_Title
					, u.UWFID as Uwf_Id
			from Forums as f
			inner join Users as u on u.UserID = f.UserID
		</cfquery>
		<cfcatch type="any">
			<cfset rtnStruct["ERROR"] = "There was an error executing the query.">
			<cfset rtnStruct["MESSAGE"] = #cfcatch#>
			<cfreturn rtnStruct>
		</cfcatch>
		</cftry>
		<cfset i = 0>
		<cfloop query="getArgoPostForums">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfloop list="#getArgoPostForums.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn)>
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>
	
	<!--- Gets a JSON object representing Threads belonging to a Forum in the ArgoPost system --->
	<cffunction name="getArgoPostThreads" access="remote" returnFormat="JSON" returnType="struct">	
		<cfargument name="f" >
		<cfset rtnStruct = structNew()>
		<cfif len(trim(#arguments.f#))>
			<cftry>
				<cfquery name="getArgoPostThreads" datasource="#theDS#">
				select 	t.ThreadId as Thread_ID
						, t.Title as Thread_Title
						, f.ForumID as Forum_ID
						, f.Title as Forum_Title
						, u.UWFID as Uwf_Id
				from (Threads as t
				inner join Forums as f on f.ForumID = t.ForumID)
				inner join Users as u on u.UserID = t.UserID
				where t.ForumId = <cfqueryparam value = "#arguments.f#" cfsqltype = "cf_sql_int">
			</cfquery>
			<cfcatch type="any">
				<cfset rtnStruct["ERROR"] = "There was an error executing the query.">
				<cfset rtnStruct["MESSAGE"] = #cfcatch#>
				<cfreturn rtnStruct>
			</cfcatch>
			</cftry>
		<cfelse> 
			<cfreturn rtnStruct>
		</cfif>
		<cfset i = 0>
		<cfloop query="getArgoPostThreads">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfloop list="#getArgoPostThreads.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn)>
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>
	
	<!--- Gets a JSON object representing Posts belong to a Thread in the ArgoPost system --->
	<cffunction name="getArgoPostPosts" access="remote" returnFormat="JSON" returnType="struct">	
		<cfargument name="t" >
		<cfset rtnStruct = structNew()>
		<cfif len(trim(#arguments.t#))>
			<cftry>
				<cfquery name="getArgoPostPosts" datasource="#theDS#">
				select 	p.PostID as Post_ID
						, p.Title as Post_Title
						, p.Description as Post_Description
						, p.EnteredDate as Post_EnteredDate
            			, p.ExpirationDate as Post_ExpirationDate
            			, p.LastModifiedDate as Post_LastModifiedDate
            			, u.UWFID as Uwf_Id
						, t.ThreadID as Thread_ID
						, t.Title as Thread_Title
						, f.ForumID as Forum_ID
						, f.Title as Forum_Title
				from ((Posts as p
				inner join Threads as t on t.ThreadID = p.ThreadID)
				inner join Forums as f on f.ForumID = t.ForumID)
				inner join Users as u on u.UserID = p.UserID
				where (p.ThreadId = <cfqueryparam value = "#arguments.t#" cfsqltype = "cf_sql_int">)
				and IsExpired = 0
			</cfquery>
			<cfcatch type="any">
				<cfset rtnStruct["ERROR"] = "There was an error executing the query.">
				<cfset rtnStruct["MESSAGE"] = #cfcatch#>
				<cfreturn rtnStruct>
			</cfcatch>
			</cftry>
		<cfelse> 
			<cfreturn rtnStruct>
		</cfif>
		<cfset i = 0>
		<cfloop query="getArgoPostPosts">
			<cfset i = i + 1>
			<cfset rtnStruct[i] = structNew()>
			<cfset rtnStruct[i]["IS_FACULTY"] = #session.isFaculty#>
			<cfset rtnStruct[i]["LOGGED_IN_USER"] = #session.userName#>
			<cfloop list="#getArgoPostPosts.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn)>
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>
</cfcomponent>