// Executes when the page is loaded
function init() 
{
	$.ajax({
			type: "GET", url: "argopost.cfc?wsdl&method=checkSession",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(response)
					{
						if(response.sessionStatus == 1)
						{
							getArgoPostForums();
						}
						else
						{
							window.location = "login.cfm";
						}
					},
			failure: function(response)
					{
						window.location = "login.cfm";	
					}
	 });
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

// Expires a post from thread-view
function deleteArgoPostFromThread(postId, threadId)
{
	$.ajax({
		type: "GET", url: "argopostdelete.cfc?wsdl&method=markExpired"
				+"&postId=" + postId + "&threadId=" + threadId,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: deleteArgoPostFromThreadSuccess,
		failure: deleteArgoPostFromThreadFail
	 });
}

// Expires a post from search-view
function deleteArgoPostFromSearch(postId)
{
	$.ajax({
		type: "GET", url: "argopostdelete.cfc?wsdl&method=markExpired"
				+"&postID=" + postId + "&threadId=-1",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: deleteArgoPostFromSearchSuccess,
		failure: deleteArgoPostFromSearchFail
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
	var keyword = document.getElementById('searchInputText').value;
	
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	$('#searchResults').empty();
	
	$('#resultsTitle').empty();
	$('#resultsTitle').append("Posts");
	$('#resultsTitle').append("&nbsp;&nbsp;&nbsp;&nbsp;<span style='font: italic 12px Helvetica, Arial, sans-serif;color:white;'>"
			+ "Search results for '" + document.getElementById('searchInputText').value + "'"
			+ "</span>"
		);
	
	if(count <= 0)
	{
		$('#searchResults').append(
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<span style='font: italic 12px Helvetica, Arial, sans-serif;color:black;'>No results found. Please try again.</span>"
				+ "</td>"
				+ "</tr>");
	}
	else
	{
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
			var isFaculty = result.IS_FACULTY;

			var deleteBtn = "&nbsp;";
			
			if(loggedInUser == userUwfId || isFaculty == 1)
			{
				deleteBtn = "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:red;text-decoration:none;' href='javascript:deleteArgoPostFromSearch("+postId+ ");'>[Delete]</a>"
				
			}
			
			if(postTitle == "")
			{
				postTitle = "N/A"
			}
			
			if(postDescription == "")
			{
				postDescription = "N/A"
			}
			
			$('#searchResults').append(
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:showArgoPostDetails(postIdContent"+postId+");'>"
				+ postTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:#333333;text-decoration:none;' href='javascript:getArgoPostThreads("+forumId+");'>[Forum]</a>"
				+ "&nbsp;&nbsp;"
				+ "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:#333333;text-decoration:none;' href='javascript:getArgoPostPosts("+threadId+");'>[Topic]</a>"
				+ "&nbsp;&nbsp;"
				+ deleteBtn
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId
				+ "</span>"
				+ "<br />"
				+ "<div class='posts' id='postIdContent"+postId+"' style='display:none;'>"
				+ "<span style='font: 12px Helvetica, Arial, sans-serif;color:black;'>"
				+ postDescription
				+ "</span></div>"
				+ "</td>"
				+ "</tr>");			
		});
	}
}

// Handles a successful response from the getArgoPostForums function
function getArgoPostForumsSuccess(response)
{
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	$('#searchResults').empty();
	
	if(count <= 0)
	{
		$('#searchResults').append(
			
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<span style='font: italic 12px Helvetica, Arial, sans-serif;color:black;'>No forums found. Please try again.</span>"
				+ "</td>"
				+ "</tr>");
	}
	else
	{
		$('#resultsTitle').empty();
		$('#resultsTitle').append("Forums");
		
		$.each(response, function(index, result)
		{  
			var forumId = result.FORUM_ID;
			var forumTitle = result.FORUM_TITLE;
			var userUwfId = result.UWF_ID;
			
			
					
			if(forumTitle == "")
			{
				forumTitle = "N/A"
			}
			
			$('#searchResults').append(
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:getArgoPostThreads("+forumId+");'>"
				+ forumTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId
				+ "</span>"
				+ "</td>"
				+ "</tr>");
		});
	}
}

// Handles a successful response from the getArgoPostThreads function
function getArgoPostThreadsSuccess(response)
{
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	$('#searchResults').empty();
	
	if(count <= 0)
	{
		$('#searchResults').append(
			
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<span style='font: italic 12px Helvetica, Arial, sans-serif;color:black;'>No threads found. Please try again.</span>"
				+ "</td>"
				+ "</tr>");
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
			
			$('#searchResults').append(
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:getArgoPostPosts("+threadId+");'>"
				+ threadTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:#333333;text-decoration:none;' href='javascript:getArgoPostForums();'>[All Forums]</a>"
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId
				+ "</span>"
				+ "</td>"
				+ "</tr>"
			);		
		});
		
		$('#resultsTitle').empty();
		$('#resultsTitle').append("Forum: " + forumTitle);
	}
}

// Handles a successful response from the getArgoPostPosts function
function getArgoPostPostsSuccess(response)
{
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	$('#searchResults').empty();
	
	if(count <= 0)
	{

		$('#searchResults').append(
			
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<span style='font: italic 12px Helvetica, Arial, sans-serif;color:black;'>No posts found. Please try again.</span>"
				+ "</td>"
				+ "</tr>");
	}
	else
	{
		var threadTitle = "";
		
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
			
			var isFaculty = result.IS_FACULTY;
			
			console.log(result.IS_FACULTY);
			
			var deleteBtn = "&nbsp;";
			
			if(loggedInUser == userUwfId || isFaculty == 1)
			{
				deleteBtn = "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:red;text-decoration:none;' href='javascript:deleteArgoPostFromThread("+postId+ "," + threadId + ");'>[Delete]</a>"
				
			}
			
			if(postTitle == "")
			{
				postTitle = "N/A"
			}
			
			if(postDescription == "")
			{
				postDescription = "N/A"
			}
			
			$('#searchResults').append(
				"<tr id='searchResultsImage'>"
				+ "<td class='photo'>"
				+ "<img src='images/smallPic.png' width='50' height='50' align='top'></img>"
				+ "</td>"
				+ "<td class='text'>"
				+ "<a style='font: bold 14px Helvetica, Arial, sans-serif;color:navy;text-decoration:none;' href='javascript:showArgoPostDetails(postIdContent"+postId+");'>"
				+ postTitle
				+ "</a>"
				+ "&nbsp;&nbsp;"
				+ "<a style='font: bold 10px Helvetica, Arial, sans-serif;color:#333333;text-decoration:none;' href='javascript:getArgoPostThreads("+forumId+");'>[Forum]</a>"
				+ "&nbsp;&nbsp;"
				+ deleteBtn
				+ "&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userUwfId
				+ "</span>"
				+ "<br />"
				+ "<div class='posts' id='postIdContent"+postId+"' style='display:none;'>"
				+ "<span style='font: 12px Helvetica, Arial, sans-serif;color:black;'>"
				+ postDescription
				+ "</span></div>"
				+ "</td>"
				+ "</tr>"
			);
		});

		$('#resultsTitle').empty();
		$('#resultsTitle').append("Topic: " + threadTitle);
	}
}

// Handles a failed response from all ArgoPost javascript functions
function getArgoPostFail(response)
{
	$('#searchResults').empty();
		
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>There was an error with the server.</span><br />");
	
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>"+response+"</span>");		
}

// Handles a failed response from deleteArgoPostThread
function deleteArgoPostFromThreadFail(response)
{
	
	$('#searchResults').empty();
		
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>There was an error with the server.</span><br />");
	
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>"+response+"</span>");		
}

// Handles a successful response from deleteArgoPostFromThread
function deleteArgoPostFromThreadSuccess(response)
{
	if(response.deleteSuccess == 1)
	{
		alert("Your post was successfully deleted");
		getArgoPostPosts(response.threadId);
	}
	
	if(response.deleteSuccess == 0)
	{
		alert("Your post could not be deleted");
	}
	
	if(response.deleteSuccess == 0)
	{
		alert("There was a problem with the server, please contact your system administrator.");
	}
}

// Handles a failed response from deleteArgoPostFromSearch
function deleteArgoPostFromSearchFail(response)
{
	$('#searchResults').empty();
		
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>There was an error with the server.</span><br />");
	
	$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>"+response+"</span>");		
}

// Handles a successful response from deleteArgoPostFromSearch
function deleteArgoPostFromSearchSuccess(response)
{
	if(response.deleteSuccess == 1)
	{
		alert("Your post was successfully deleted");
		getArgoPostSearchResults();
	}
	
	if(response.deleteSuccess == 0)
	{
		alert("Your post could not be deleted");
	}
	
	if(response.deleteSuccess == 0)
	{
		alert("There was a problem with the server, please contact your system administrator.");
	}
}

// Clears the value in an HTMLInput object 
function clearInput(controlId)
{
	//$(controlId).val('');
	document.getElementById(controlId).value = '';
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