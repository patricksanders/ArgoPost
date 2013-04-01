
// Sends a query to the getSearchResults method in tier 2
function getSearchResults()
{
	console.log("post getSearchResults() call");
	
	$.ajax({
		type: "GET", url: "http://localhost:8888/argopost/argopost.cfc?wsdl&method=getSearchResults",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: getSearchResultsSuccess,
		failure: getSearchResultsFail
	 });
	
	console.log("done getSearchResults() call");
}

// Handles a successful response from the getSearchResults function
function getSearchResultsSuccess(response)
{
	console.log("getSearchResults() success");
	
	console.log("begin iterateing");
	
	$('#searchResults').empty();
	
	$.each(response, function(key,value)
	{  
		console.log(key + ":" + value);
		$('#searchResults').append(key + ":" + value + ' <br />');
	});
	
	console.log("done iterateing");
}

// Handles a failed response from the getSearchResults function
function getSearchResultsFail(response)
{
	console.log("getSearchResults failed with the following message: " + response);
}

// Clears the value in an HTMLInput object 
function clearInput(controlId)
{
	$(controlId).val('');
}

// Allows this javascript library to include other javascript libraries
function IncludeJavaScript(jsFile)
{
  document.write('<script type="text/javascript" src="'
    + jsFile + '"></scr' + 'ipt>'); 
}

// Include the jQuery library hosted at Google
IncludeJavaScript('//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js');