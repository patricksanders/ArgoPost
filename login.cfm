<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ArgoPost LogIn</title>


<!-- 
		Example by: Breanna Garrett
		Date:	Feb 9 ,2012
        Contact: bgarrett1@uwf.edu
		
		Edited by: Andy Milbeck
		Date: Apr 19, 2013
		Contact: ajm46@students.uwf.edu
        
 -->
</head>

<body>

<!--
		Things to note about this code:
        This a custom CF tag defined on the server used to autheticate user login on ArgoNet.
        	- Normally application variables are wiped after this is called for some weird reason, so a work around was added (activateApplicate = "false").
         Known Bugs:
         	- When a user enters the wrong login information or does not have access, the content that shows up below the login disapears. Unfortinately, if you have
              any content other than </body></html> after the login, it will not display unless you have the content in a seperate file and included in the footer variable as 
              shown below. 
         Variables:
         	- There are several usable variables that become available after the user logs in... 
            	- #argoUserID# - this number is very similar to the UWF ID number except the second digit is not a 7, please do not use this information for personal gain.
       			- #argoUsername# - username
        	  	- #argofirstname# #argolastname# - name

-->

<!-- defined session variable: This variable is defined in applications.cfc. It is created when the session begins.  -->
<cfif session.loggedIn eq 0>
        <cfsavecontent variable="footer"><cfinclude template ="index_login_foot.cfm"></cfsavecontent>
     	<cf_uwfLogin loginTimeout="30"
			loginWelcome="<div align = 'center'><strong>Login</strong></div>"
			logoutMessage="You have logged out of the system."
			logoutURL="login.cfm"
			loginIDName="Username"
			loginKeyName="Password"
            numericidname = "argoUserID"
			IDVarName="argoUsername"
			firstnamevarname="argofirstname"
            lastnamevarname="argolastname"
            loginfailuremessage = "<p style = 'font-size: 12px;'>You could not be logged in with the information provided. Please <a href = 'login.cfm'>try again.</a></p>"
            activateApplication = "false"
    		footer="#footer#">            
			
			<cfset session.loggedIn = 1>
			<cfset session.userName=#argoUserName#>

			<cfinvoke
				component="User"
				method="setUpUser">
			</cfinvoke>

			<cfinvoke
				component="User"
				method="findUser"
				returnVariable="userExists">
			</cfinvoke>

			<cfif userExists eq true>
				<cflocation url="index.cfm">
			<cfelse>			
				<cfinvoke
					component="User"
					method="insertUser">
				</cfinvoke>
				<cflocation url="index.cfm">
			</cfif>			
            
<!--
		Any additional login requirements can be done here. For example, if you had some sort of security system, one could set security status here based on user id. You can even restrict who
        can login. Be sure to set some sort of session.loggedIn to 1 to show the user has been authenticated and can browse the site. You will need to make some code to check this condition on EVERY
        protected page. My advise: make a cfif statement in the application.cfc function onRequestStart that will analyze the URL path to see if the user can access it. You can get the URL path of 
        the page in the cgi scope. (cgi.path_info) 
        
        In ColdFusion, sessions end when they time out based on the time span created in the application.cfc or when the browser closes. Because of this, you will need to reset all session scope variables
        on your logout page.
        
        To go to a different page other than this one when you login use <cflocation url="whereever.cfm" addtoken="no" /> Note: the addtoken value is nessesary, otherwise it will append session and token ids
        to the URL which is just garbage (and kind of bad looking).
        
        Note: Try not to pass sensitive user information across url param (?userid=xxxx)
        
        When processing user input make sure you use #HTMLEditFormat(trim(form.input_var_name))# to convert all HTML/script code to a non-malicious form. Don't use this if you have a formatted input such as
        a textarea with advanced formatting.
        
        
        Good luck!
--->
<cfelse>
	<cflocation url="index.cfm">
</cfif>

</body>
</html>