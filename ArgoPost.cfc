<cfcomponent>
	<cfset theDS="seproject_argopost"> <!--- Name the datasource --->
	
	<cffunction name="getSearchResults" access="remote" returnFormat="plain" returnType="string">
		<cfquery name="getUsers" dataSource="#theDS#">
			select * 
			from Users 
			where Users.name = "Ryan"
		</cfquery>
		
		<cfset rtnStruct = structNew() >
		
		<cfloop query="getUsers">
			<cfset rtnStruct[id] = structNew()  >
			<cfloop list="#getUsers.columnList#" index="thisColumn">
				<cfset rtnStruct[Id][thisColumn] = evaluate(thisColumn) >
			</cfloop>
		</cfloop>
		
		<cfreturn rtnStruct >
	</cffunction>
	
	<cffunction name="test" access="remote" returnFormat="JSON" returnType="struct">
		<cfset rtnVal = structNew()>
		<cfset rtnVal.A = "B">
		<cfset rtnVal.B = "C">
		<cfreturn rtnVal>
	</cffunction>
	
	
	<cffunction name="sayHello" access="remote" returnFormat="plain" returnType="string">
		<cfreturn "Hello from sayHello()" >
	</cffunction>
	
	<!---
	<cffunction name="exampleUpdateFunction" access="remote" returnType="void">
		<cfquery name="updatePerson" dataSource="#theDS#">
			update set name = <cfquery paramValue="#arguments.aPersonID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>
	</cffunction>
	--->

	<!--- An example of a select query (returing a struct --->
	<cffunction name="exampleSelectFunctionS" access="remote" returnFormat="JSON" returnType = "query">
		<cfquery name="getPeople" dataSource="#theDS#">
			select * from Users	
		</cfquery>
		
		<cfset return = structNew()>
	</cffunction>
	
  <cffunction name="getArgoPostItem" access="remote" returnFormat="JSON" returnType="struct">
    <cfargument name="ID" required="yes" type="numeric">
    <cfargument name="IDType" required="yes" type="numeric">
    
    <cfset rtnVal = structNew()>
    
    <!--- not sure if the following variables are even needed......yea --->
    <cfset Id = "ID">
    <cfset IdTy = "IDType">
    
    <!--- if above variables are not needed than replace cfif condition with the following --->
    <!--- <cfif IDType eq 0> --->
    <cfif IdTy eq 0>
      <cfquery name="getForum" dataSource="#theDS#">
        select * 
        from UserID, Title 
        where ForumID = "Id"
      </cfquery>
      <cfreturn serializeJSON(getForum)>
      <!--- or this/does this even work? --->
      <!--- <cfset rtnval = serializeJSON(getForum)> --->
      
    <!--- if above variables are not needed than replace cfif condition with the following --->
    <!--- <cfif IDType eq 1> --->
    <cfelseif IdTy eq 1>
      <cfquery name="getThread" dataSource="#theDS#">
        select * 
        from UserID, ForumID, Title 
        where TheadID = "Id"
      </cfquery>
      <cfreturn serializeJSON(getThread)>
    
    <!--- if above variables are not needed than replace cfif condition with the following --->
    <!--- <cfif IDType eq 2> --->
    <cfelseif IdTy eq 2>
       <cfquery name="getPost" dataSource="#theDS#">
        select * 
        from UserID, ThreadID, LastModifiedDate, EnteredDate, ExpirationDate, Title, Description, IsExpired
        where PostID = "Id"
      </cfquery>
      <cfreturn serializeJSON(getPost)>
    
    <cfelse>
      <!--- error handleing if ( IdTy != (0 || 1 || 2) ) --->
      <cfreturn rtnVal>
    </cfif> 
    
    <!--- if the above cod in question does wrk i assume do this?? --->
    <!--- <cfoutput>#rtnval#</cfoutput> --->
    <!--- || --->
    <!--- <cfreturn rtnval> --->

  </cffunction>
</cfcomponent>