
<!-- Clear/reset session scope -->
<cfset session.loggedIn = 0>
<cfset session.security = 0>
<cfset session.isFaculty = 0>
<cfset session.userName = "">
<cfset session.emailAddress = "">


<cfset url.logout = 1>
<cf_uwflogin logoutURL="http://uwf.edu/seproject/TestDeployment/login.html">

<cflocation url = "http://uwf.edu/seproject/TestDeployment/login.html" addtoken="no">
