
<!-- Clear/reset session scope -->
<cfset session.loggedIn = 0>
<cfset session.security = 0>




<cfset url.logout = 1>
<cf_uwflogin logoutURL="http://uwf.edu/">

<cflocation url = "http://uwf.edu/" addtoken="no">
