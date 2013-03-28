<cfcomponent>
	<cfset theDS="argopost_db"> <!--- Name the datasource --->
	
	<!--- An example of a select query returning the result of the query --->
	
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
</cfcomponent>