
// Sends a query to the getSearchResults method in tier 2
function getArgoPostSearchResults()
{
	$.ajax({
		type: "GET", url: "argopost.cfc?wsdl&method=getArgoPostSearchResults"
				+"&s=" 	+ document.getElementById('searchInputText').value,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: getArgoPostSearchResultsSuccess,
		failure: getArgoPostSearchResultsFail
	 });
}

// Shows the details of an ArgoPost
function showArgoPostDetails(argoPostItem)
{
	$('.posts').each(function(index) 
	{
		console.log("iterating");
    	if ($(this).attr("id") == $(argoPostItem).attr("id")) 
    	{
        	console.log("found you");
        	$(this).show(200);
        }
        else 
        {
        	$(this).hide(600);
    	}
    });
}

// Handles a successful response from the getSearchResults function
function getArgoPostSearchResultsSuccess(response)
{
	console.log("BACK");
	
	var count = 0;
	$.each(response, function(k, v) { count++; });
	
	if(count <= 0)
	{
		$('#searchResults').empty();
		
		$('#searchResults').append("<span style='font: italic 12px Helvetica, Arial, sans-serif;color:gray;'>No results found. Please try again.</span>");	
	}
	else
	{
		$('#searchResults').empty();
		
		$.each(response, function(index, result)
		{  
			var postId = result.POST_ID;
			var postTitle = result.POST_TITLE;
			var postDescription = result.POST_DESCRIPTION;
			var createdDate = result.POST_ENTEREDDATE
			var userEmail = result.USER_EMAIL;
			
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
				+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
				+ "<span style='font: italic 10px Helvetica, Arial, sans-serif;color:gray;'>Created by "
				+ userEmail
				+ " on " + createdDate
				+ "</span>"
				+ "<br />"
				+ "<div class='posts' id='postIdContent"+postId+"' style='display: none;'>"
				+ "<span style='font: 12px Helvetica, Arial, sans-serif;color:black;'>"
				+ postDescription
				+ "</span></div>"
			);
			
			$('#searchResults').append("</p>");
		});
	}
}

// Handles a failed response from the getSearchResults function
function getArgoPostSearchResultsFail(response)
{
	console.log("FAIL");
	
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