
<!-- Clear/reset session scope -->
<cfset session.loggedIn = 0>
<cfset session.security = 0>
<cfset session.isFaculty = 0>
<cfset session.userName = "">
<cfset session.emailAddress = "">


<cfset url.logout = 1>

<cflocation url = "login.cfm" addtoken="no">
