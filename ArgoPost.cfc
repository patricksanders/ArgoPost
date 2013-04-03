<cfcomponent>
	<cfset theDS="seproject_argopost">
	<cffunction name="getArgoPostSearchResults" access="remote" returnFormat="JSON" returnType="struct">	
		<cfargument name="s" >
		<cfset rtnStruct = structNew()>
		<cfif len(trim(#arguments.s#))>
			<cftry>
				<cfquery name="getArgoPostSearchResults" datasource="#theDS#">
				select 	p.PostID 'Post_ID'
						, p.Title 'Post_Title'
						, p.Description 'Post_Description'
						, p.EnteredDate 'Post_EnteredDate'
            			, p.ExpirationDate 'Post_ExpirationDate'
            			, p.LastModifiedDate 'Post_LastModifiedDate'
            			, u.Email 'User_Email'
						, t.ThreadID 'Thread_ID'
						, t.Title 'Thread_Title'
						, f.ForumID 'Forum_ID'
						, f.Title 'Forum_Title'
				from Posts as p
				inner join Threads as t on t.ThreadID = p.ThreadID
				inner join Forums as f on f.ForumID = t.ForumID
				inner join Users as u on u.UserID = p.UserID
				where LOWER(p.Title) like LOWER(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LOWER(p.Description) like LOWER(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LOWER(t.Title) like LOWER(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LOWER(f.Title) like LOWER(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				or LOWER(u.Email) like LOWER(<cfqueryparam value = "%#arguments.s#%" cfsqltype = "cf_sql_char" maxLength = "40">)
				order by p.EnteredDate desc
			</cfquery>
			<cfcatch type="any">
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
			<cfloop list="#getArgoPostSearchResults.columnList#" index="thisColumn">
				<cfset rtnStruct[i][thisColumn] = evaluate(thisColumn) >
			</cfloop>
		</cfloop>
		<cfreturn rtnStruct>
	</cffunction>
	<cffunction name="getArgoPostItem" access="remote" returnFormat="JSON" returnType="struct">	
		<cfargument name="ID" >
		<cfset rtnStruct = structNew()>
    <cftry>
      <cfquery name="getArgoPostItem" datasource="#theDS#">
      select 	p.PostID 'Post_ID'
          , p.Title 'Post_Title'
          , p.Description 'Post_Description'
          , p.EnteredDate 'Post_EnteredDate'
                , p.ExpirationDate 'Post_ExpirationDate'
                , p.LastModifiedDate 'Post_LastModifiedDate'
                , u.Email 'User_Email'
          , t.ThreadID 'Thread_ID'
          , t.Title 'Thread_Title'
          , f.ForumID 'Forum_ID'
          , f.Title 'Forum_Title'
      from Posts as p
      inner join Threads as t on t.ThreadID = p.ThreadID
      inner join Forums as f on f.ForumID = t.ForumID
      inner join Users as u on u.UserID = p.UserID
      where LOWER(p.Title) like LOWER(<cfqueryparam value = "%#arguments.ID#%" cfsqltype = "cf_sql_char" maxLength = "40">)
      or LOWER(p.Description) like LOWER(<cfqueryparam value = "%#arguments.ID#%" cfsqltype = "cf_sql_char" maxLength = "40">)
      or LOWER(t.Title) like LOWER(<cfqueryparam value = "%#arguments.ID#%" cfsqltype = "cf_sql_char" maxLength = "40">)
      or LOWER(f.Title) like LOWER(<cfqueryparam value = "%#arguments.ID#%" cfsqltype = "cf_sql_char" maxLength = "40">)
      or LOWER(u.Email) like LOWER(<cfqueryparam value = "%#arguments.ID#%" cfsqltype = "cf_sql_char" maxLength = "40">)
      order by p.EnteredDate desc
    </cfquery>
    <cfcatch type="any">
      <cfreturn rtnStruct>
    </cfcatch>
    </cftry>
		<cfreturn rtnStruct>
	</cffunction>
</cfcomponent>