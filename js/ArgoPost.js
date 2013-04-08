// Executes when the page is loaded
function init() 
{
	// Get the URL and split it by "/"
	var pathArray = window.location.pathname.split( '/' );
 	
 	// Do something if on the searchpage.html or searchpage.cfm
 	if(pathArray[pathArray.length-1] == "searchpage.cfm")
 	{
 		getArgoPostForums();
 	}
}

// Sends a query to the getArgoPostSearchResults method in tier 2
function getArgoPostSearchResults()
{
	$.ajax({
		type: "GET", url: "argopost.cfc?wsdl&method=getArgoPostSearchResults"
				+"&s=" 	+ document.getElementById('searchInputText').value,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: getArgoPostSearchResultsSuccess,
		failure: getArgoPostFail
	 });
}

// Sends a query to the getArgoPostForums method in tier 2
function getArgoPostForums()
{
	$.ajax({
		type: "GET", url: "argopost.cfc?wsdl&method=getArgoPostForums" ,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: getArgoPostForumsSuccess,
		failure: getArgoPostFail
	 });
}

// Sends a query to the getArgoPostForums method in tier 2
function getArgoPostThreads(forumId)
{
	$.ajax({
		type: "GET", url: "argopost.cfc?wsdl&method=getArgoPostThreads&f=" + forumId ,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: getArgoPostThreadsSuccess,
		failure: getArgoPostFail
	 });
}

// Sends a query to the getArgoPostPosts method in tier 2
function getArgoPostPosts(threadId)
{
	$.ajax({
		type: "GET", url: "argopost.cfc?wsdl&method=getArgoPostPosts&t=" + threadId ,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: getArgoPostPostsSuccess,
		failure: getArgoPostFail
	 });
}




// Shows/hides the details of an ArgoPost
function showArgoPostDetails(argoPostItem)
{
	$('.posts').each(function(index) 
	{
    	if ($(this).attr("id") == $(argoPostItem).attr("id")) 
    	{
        	$(this).show(200);
        }
        else 
        {
        	$(this).hide(400);
    	}
    });
}



// Handles a successful response from the getSearchResults function
function getArgoPostSearchResultsSuccess(response)
{
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	$('#searchResults').empty();
	
	$('#searchResults').append("<p><span style='font: italic 12px Helvetica, Arial, sans-serif;color:#333;'>"
			+ "Search results for '" + document.getElementById('searchInputText').value + "'"
			+ "</span></p>"
		);
	
	if(count <= 0)
	{

		$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:red;'>No results found. Please try again.</span>");	
	}
	else
	{
		$('#searchResults').append("<p><span id='threadTitle' style='font: italic 14px Helvetica, Arial, sans-serif;color:#333;text-decoration:underline;'>Posts</span></p>"
		);
		

		$.each(response, function(index, result)
		{  
			var postId = result.POST_ID;
			var postTitle = result.POST_TITLE;
			var postDescription = result.POST_DESCRIPTION;
			var createdDate = result.POST_ENTEREDDATE
			var userUwfId = result.UWF_ID;
			var forumId = result.FORUM_ID;
			var threadId = result.THREAD_ID;
			var loggedInUser = result.LOGGED_IN_USER;

			var deleteBtn = "&nbsp;";
			
			if(loggedInUser == userUwfId)
			{
				deleteBtn = "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:red;text-decoration:none;' href='javascript:deleteArgoPost("+postId+");'>[Delete]</a>"
				
			}
			
			if(postTitle == "")
			{
				postTitle = "N/A"
			}
			
			if(postDescription == "")
			{
				postDescription = "N/A"
			}
			
			$('#searchResults').append("<p>");
			
			$('#searchResults').append(
				"<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:showArgoPostDetails(postIdContent"+postId+");'>"
				+ postTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:#333333;text-decoration:none;' href='javascript:getArgoPostThreads("+forumId+");'>[Forum]</a>"
				+ "&nbsp;&nbsp;"
				+ "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:#333333;text-decoration:none;' href='javascript:getArgoPostPosts("+threadId+");'>[Thread]</a>"
				+ "&nbsp;&nbsp;"
				+ deleteBtn
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId + " on " + createdDate
				+ "</span>"
				+ "<br />"
				+ "<div class='posts' id='postIdContent"+postId+"' style='display:none;'>"
				+ "<span style='font: 12px Helvetica, Arial, sans-serif;color:black;'>"
				+ postDescription
				+ "</span></div>"
			);
			
			$('#searchResults').append("</p>");
			
		});
	}
}


// Handles a successful response from the getArgoPostForums function
function getArgoPostForumsSuccess(response)
{
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	console.log("Forums found: " + count);
	
	$('#searchResults').empty();
	
	if(count <= 0)
	{
		$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:red;'>No Forums found. Please try again later.</span>");	
	}
	else
	{
		$('#searchResults').append("<p><span id='threadTitle' style='font: italic 14px Helvetica, Arial, sans-serif;color:#333;text-decoration:underline;'>Forums</span></p>"
		);
		
		$('#searchResults').append("<p>");
		
		$.each(response, function(index, result)
		{  
			var forumId = result.FORUM_ID;
			var forumTitle = result.FORUM_TITLE;
			var userUwfId = result.UWF_ID;
					
			if(forumTitle == "")
			{
				forumTitle = "N/A"
			}
			
			$('#searchResults').append("<p>");
			
			$('#searchResults').append(
				"<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:getArgoPostThreads("+forumId+");'>"
				+ forumTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId
				+ "</span>"
			);
			
			$('#searchResults').append("</p>");
		});
	}
}

// Handles a successful response from the getArgoPostThreads function
function getArgoPostThreadsSuccess(response)
{
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	$('#searchResults').empty();
	
	$('#searchResults').append("<p><span id='forumTitle' style='font: italic 14px Helvetica, Arial, sans-serif;color:#333;'></span></p>"
		);
	
	if(count <= 0)
	{
		$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:red;'>No Threads found. Please try again.</span>");	
	}
	else
	{
		var forumTitle = "";
		

		
		$.each(response, function(index, result)
		{  
			var threadId = result.THREAD_ID;
			var threadTitle = result.THREAD_TITLE;
			var userUwfId = result.UWF_ID;
			
			forumTitle = result.FORUM_TITLE;
					
			if(threadTitle == "")
			{
				postTitle = "N/A"
			}
			
			$('#searchResults').append("<p>");
			
			$('#searchResults').append(
				"<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:getArgoPostPosts("+threadId+");'>"
				+ threadTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId
				+ "</span>"
			);
				
			$('#searchResults').append("</p>");
			
			
		});
		
		$('#forumTitle').append("Forum: " + forumTitle);
	}
}


// Handles a successful response from the getArgoPostPosts function
function getArgoPostPostsSuccess(response)
{
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	$('#searchResults').empty();
	
	$('#searchResults').append("<p><span id='threadTitle' style='font: italic 14px Helvetica, Arial, sans-serif;color:#333;'></span></p>"
		);
	
	if(count <= 0)
	{

		$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:red;'>No Posts found. Please try again.</span>");	
	}
	else
	{
		var threadTitle = "";
		
		$('#searchResults').append("<p><span id='threadTitle' style='font: italic 14px Helvetica, Arial, sans-serif;color:#333;text-decoration:underline;'>Posts</span></p>"
		);
		
		$.each(response, function(index, result)
		{  
			var postId = result.POST_ID;
			var postTitle = result.POST_TITLE;
			var postDescription = result.POST_DESCRIPTION;
			var createdDate = result.POST_ENTEREDDATE
			var userUwfId = result.UWF_ID;
			var forumId = result.FORUM_ID;
			var threadId = result.THREAD_ID;
			
			threadTitle = result.THREAD_TITLE;
			
			var loggedInUser = result.LOGGED_IN_USER;

			var deleteBtn = "&nbsp;";
			
			if(loggedInUser == userUwfId)
			{
				deleteBtn = "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:red;text-decoration:none;' href='javascript:deleteArgoPost("+postId+");'>[Delete]</a>"
				
			}
			
			if(postTitle == "")
			{
				postTitle = "N/A"
			}
			
			if(postDescription == "")
			{
				postDescription = "N/A"
			}
			
			$('#searchResults').append("<p>");
			
			$('#searchResults').append(
				"<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:showArgoPostDetails(postIdContent"+postId+");'>"
				+ postTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:#333333;text-decoration:none;' href='javascript:getArgoPostThreads("+forumId+");'>[Forum]</a>"
				+ "&nbsp;&nbsp;"
				+ deleteBtn
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId + " on " + createdDate
				+ "</span>"
				+ "<br />"
				+ "<div class='posts' id='postIdContent"+postId+"' style='display:none;'>"
				+ "<span style='font: 12px Helvetica, Arial, sans-serif;color:black;'>"
				+ postDescription
				+ "</span></div>"
			);
			
			$('#searchResults').append("</p>");
			
			
			
		});
		
		$('#threadTitle').append("Thread: " + threadTitle);
	}
}


// Handles a failed response from all ArgoPost javascript functions
function getArgoPostFail(response)
{
	$('#searchResults').empty();
		
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>There was an error with the server.</span><br />");
	
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>"+response+"</span>");		
}


// Allows this javascript library to include other javascript libraries
function IncludeJavaScript(jsFile)
{
  document.write('<script type="text/javascript" src="'
    + jsFile + '"></scr' + 'ipt>'); 
}

// Include the jQuery library hosted at Google
IncludeJavaScript('//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js');

window.onload = init
