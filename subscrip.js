function createSubscription() {	
	//get thread title from the dropdown menu in the post UI
	var aThreadID = document.getElementById("threads");
	//get forum title from dropdown menu in the post UI
	var aForumTitle = document.getElementById("forums");
	//this variable is used to check if a field was left empty
	var isEmptyField = false;
	
	//check that a thread has been selected
	if(aThreadID.value == "Select a thread"){
		isEmptyField = true;
	}
	//check that a forum has been selected
	if(aForumTitle.value == "Select a forum"){
		isEmptyField = true;
	}
	//if there is an empty field send user back to post page with an error
	//explaining that all fields must be completed
	if (isEmptyField === true) {
		alert("You must select a forum and thread.");

	} 
	else {
		$.ajax({
			type : "GET",
			url : "Subscriber.cfc?wsdl&method=AddToSubscriptions&ThreadID="+aThreadID.value,
			success : subscriptionSucceeded,
			failure : failedToAddSubscription
		});
	}
}

function subscriptionSucceeded(response) {
	
	alert("Your subscription was successfully created!");
}

function failedToAddSubscription() {
	document.getElementById('addSubFailure').innerHTML = "*Subscription was not successfully created. Please try again."
	
}

/**
 *This function will run when the create post page is loaded. It will fill the Forums drop down menu with the list of forum titles.
 */
function getSubsTitles() {
		$.ajax({
			type : "GET",
			url : "Subscriber.cfc?wsdl&method=getSubs",
			contentType : "application/json; charset=utf-8",
			dataType : "json",
			success : populateSubComboBox,
			failure : failedToGetSubTitles
		});
}

/**
 *This function will run when the forum titles have successfully been returned from the database. 
 */
function populateSubComboBox(response) {
	
	$('#subscrips').empty();
	$('#subscrips').append("<option>Select a forum</option>");
	
	$.each(response, function(index, result){
		var threadId = result.THREADID;
		
		$('#subscrips').append("<option value='" + threadId + "'>" + threadId + "</option>");
	});	
}


/**
 * Thi function will execute if there is an error accessing the forum titles from the webservice 
 */
function failedToGetSubTitles(response){
	alert("Could not load the Subscriptions. Please refresh the page and try again.")
}
