<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- ArgoPost UI Team Version 1.0 -->
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>ArgoPost</title>
	<link rel="stylesheet" href="css/style.css" type="text/css">
	<script type="text/javascript" src="js/ArgoPost.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	<script type="text/javascript" src="createPost.js"></script>
</head>
<body>
	<div id="header">
		<div>
			<a href="main.cfm" id="logo"><img src="images/logo.png" alt="logo"></a>
			<ul>
				<li class="selected">
					<a href="main.cfm">Home</a>
				</li>
				<li>
					<a href="subscriptions.html">Subscriptions</a>
				</li>
				<li>
					<a href="createpost.html">Create Post</a>
				</li>
				<li>
					<a href="">Logout</a>
				</li>

			</ul>
		</div>
	</div>
	<div id="body">
	
	<div id="searchControls">			
			<input id="searchInputText" type="text" size="30" value="enter keyword here" onkeydown="if (event.keyCode == 13) document.getElementById('searchButton').click()" onclick="clearInput(searchInputText);">
			<input type="button" class="submit" id="searchButton" value="Search" onclick="getArgoPostSearchResults();">		
	</div>
	
	
	<div class="page_title">
		<h2 id="resultsTitle">Forums</h2>		
	</div>
	
	<div class="ad_list">
	
	<!--This table's category(s) will change once integrated with working functions. It's current purpose is for design. -->
	<table border="0" cellspacing="0">
	<tbody id="searchResults">
	
		<!--<tr> to </tr> is each row in the table -->
		<tr id="searchResultsImage">
		<td class="photo">
			<img src="images/smallPic.png" width="50" height="50" align="top"></img>
		</td>
		<td class="text" id="searchResultsContent">
			<h3></h3>
		</td>
		</tr>	
	
	</tbody>
	</table>
	
	</div>
	</div>
	<div id="footer">
		<div>
			<p>
				&#169; UWF ArgoPost. All Rights Reserved.
			</p>
			<div class="connect">


					<a href="main.html">Home</a>

					<a href="subscriptions.html">Subscriptions</a>

					<a href="createpost.html">Create Post</a>

					<a href="">Logout</a>
	

			</div>
		</div>
	</div>
</body>
</html>