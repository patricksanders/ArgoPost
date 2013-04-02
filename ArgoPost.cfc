<cfcomponent>
	<cfset theDS="seproject_argopost"> <!--- Name the datasource --->
	
	<cffunction name="getSearchResults" access="remote" returnFormat="JSON" returnType="struct">
		<cfquery name="getUsers" dataSource="#theDS#">
			select * 
			from Posts 
		</cfquery>
		
		<cfset rtnStruct = structNew() >
		
		<cfloop query="getUsers">
			<cfset rtnStruct[PostId] = structNew()  >
			<cfloop list="#getUsers.columnList#" index="thisColumn">
				<cfset rtnStruct[PostId][thisColumn] = evaluate(thisColumn) >
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
    
    <cfset rtnVal = structNew()>
    
    <!--- not sure if the following variables are even needed......yea --->
    <cfset Id = "ID">
 
    <cfquery name="getPost" dataSource="#theDS#">
     select * 
     from UserID, ThreadID, LastModifiedDate, EnteredDate, ExpirationDate, Title, Description, IsExpired
     where PostID = "Id"
    </cfquery>
    <cfreturn serializeJSON(getPost)>
    
      <!--- error handleing reconstruction?  --->
    
    <cfreturn rtnVal>

    <!--- if the above code in question does work i assume do this?? --->
    <!--- <cfoutput>#rtnval#</cfoutput> --->
    <!--- || --->
    <!--- <cfreturn rtnval> --->

  </cffunction>


</cfcomponent>