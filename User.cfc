<cfcomponent>
	<cfset dataSource = "SEproject_argopost">
	
	<!--- This function acts as the constructor for a user. It will be used to set the values of isFaculty and the email address
	of each user --->
	<cffunction name="setUpUser" access="public" output="false" returntype="void">
		<!--- set isFaculty --->
		<cfinvoke
			component="User"
			method="setIsFaculty">
		</cfinvoke>
		<!--- set email address --->
		<cfinvoke
			component="User"
			method="setEmail">
		</cfinvoke>		
		
	</cffunction>
	<!---  --->
	<cffunction name="getUserName" access="remote" output="false" returntype="string">
		<!--- This function returns the userID of the current user of a session. --->
		<cfreturn #session.userName#>
	</cffunction>
	
	<!--- This function checks to see if a userName has numbers in it. If a number is found in the username 
	then a user is a student and the isFaculty variable will be set to false, A userName without numbers is 
	a faculty or staff member and the isFaculty variable will be set to true. In order to communicate with the database 
	correctly the value stored in isFaculty must be 0 for false and 1 for true --->
	<cffunction name="setIsFaculty" access="public" output="false" returnType="void">		
		<cfif REFind("[^A-Za-z]", #session.userName#) eq 0>	
			<cfset session.isFaculty = 1>
		<cfelse>
			<cfset session.isFaculty = 0>
		</cfif>		
	</cffunction>	
	
	<!--- This function returns the value of the isFaculty session variable --->
	<cffunction name="getIsFaculty" access="public" output="false" returnType="numeric">
		<cfreturn #session.isFaculty#>
	</cffunction>
	
	<!--- This function is used to reconstruct a users email address. The isFaculty variable
		can be used to determine if a users email should be @uwf.edu or @students.uwf.edu --->	
	<cffunction name="setEmail" access="public" output="false" returntype="void">
		<cfset facEmail = "@uwf.edu">
		<cfset studentEmail = "@students.uwf.edu">		
		<cfif session.isFaculty eq 0>
			<cfset session.emailAddress = session.userName & studentEmail>
		<cfelse>
			<cfset session.emailAddress = session.userName & facEmail>
		</cfif>	
	</cffunction>
	
	<!--- This function returns the current user's email address --->
	<cffunction name="getEmail" access="public" output="false" returnType="string">
		<cfreturn #session.emailAddress#>
	</cffunction>	
	
	<!--- This function searches for a user in the database to see if their username has already been stored 
		If a user has not been previously stored in the database the function will return false, prompting
		the user to be inserted into the database. If a user is found the function will return true and a user 
		can be redirected to the homepage of ArgoPost, there is no need to store each user more than once. --->
	<cffunction name="findUser" access="public" output="false" returntype="boolean" >		
		<cfquery name="findUserQuery" datasource="#dataSource#" result="res">
			select UWFID
			from Users
			where UWFID = '#session.userName#';
		</cfquery>		
		<cfif findUserQuery.RecordCount eq 1>
			<cfreturn true>
		</cfif>		
		<cfreturn false>		
	</cffunction>
	
	<!--- This function is used to insert a user and their related data into the database.--->
	<cffunction name="insertUser" access="public" output="false" returnType="void">
		<cfquery name="addUserQuery" datasource="#dataSource#">
				INSERT INTO USERS(UWFID, Email, FacStaff)
				VALUES('#session.userName#', '#session.emailAddress#', '#session.isFaculty#');
		</cfquery>
	</cffunction>

</cfcomponent>