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
 *This function will run when the subscription page is loaded. It will fill the topics drop down menu with the list of topics.
 */
function getSubTitles() {
		$.ajax({
			type : "GET",
			url : "Subscriber.cfc?wsdl&method=getSubs",
			contentType : "application/json; charset=utf-8",
			dataType : "json",
			success : populateForumsComboBox,
			failure : failedToGetSubTitles
		});
}
/**
 *This function will run when the forum titles have successfully been returned from the database. 
 */
function populateSubComboBox(response) {
	
	$('#subscrips').empty();
	$('#subscrips').append("<option>Select a topic</option>");
	
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
/**
 *This function will run when the create post page is loaded. It will fill the Forums drop down menu with the list of forum titles.
 */
function getForumTitles() {
		$.ajax({
			type : "GET",
			url : "Post.cfc?wsdl&method=getForums",
			contentType : "application/json; charset=utf-8",
			dataType : "json",
			success : populateForumsComboBox,
			failure : failedToGetForumTitles
		});
}

/**
 *This function will run when the forum titles have successfully been returned from the database. 
 */
function populateForumsComboBox(response) {
	
	$('#forums').empty();
	$('#forums').append("<option>Select a forum</option>");
	
	$.each(response, function(index, result){
		var forumId = result.FORUMID;
		var forumTitle = result.TITLE;
		
		$('#forums').append("<option value='" + forumId + "'>" + forumTitle + "</option>");
	});	
}


/**
 * Thi function will execute if there is an error accessing the forum titles from the webservice 
 */
function failedToGetForumTitles(response){
	alert("Could not load the forum titles. Please refresh the page and try again.")
}

/**
 *This function will run once the user has selected a Forum in the drop down menu. It will fill the Threads drop down menu with all the threads in the
 * forum that the user has selected.
 */
function getThreadTitles() {
	var frmID = document.getElementById("forums");
	
	$.ajax({
			type : "GET",
			url : "Post.cfc?wsdl&method=getThreads&forumID="+frmID.value,
			contentType : "application/json; charset=utf-8",
			dataType : "json",
			success : populateThreadsComboBox,
			failure : failedToGetThreadTitles
		});
}

/**
 * This function will populate the threads combo box based on the selection of the forums conbo box 
 */
function populateThreadsComboBox(response){
	
	$('#threads').empty();
	$('#threads').append("<option>Select a thread</option>");
	
	$.each(response, function(index, result){
		var threadId = result.THREADID;
		var threadTitle = result.TITLE;
		
		$('#threads').append("<option value='" + threadId + "'>" + threadTitle + "</option>");
	});
}

/**
 *This function will run if there is an error getting the thread titles from the database 
 */
function failedToGetThreadTitles(){
	alert("Could not load thread titles. Please refresh the page and try again.")
}

/**
 * This function is used to check if a user is loggedIn before they are allowed to create a post. 
 */
function checkLoggedInStatus(){
	$.ajax({
			type : "GET",
			url : "Post.cfc?wsdl&method=checkIfLoggedIn",
			contentType : "application/json; charset=utf-8",
			dataType : "json",
			success : userIsLoggedIn,
			failure : loggedInStatusFailed
		});
}

/**
 *What to do if a user is logged in 
 */
function userIsLoggedIn(response){
	if(response === true){
		getForumTitles();
		getSubTites();
	}
	else{
		window.location = "login.cfm";
	}
}

/**
 * What to do if checking the users logged in status has failed. 
 */
function loggedInStatusFailed(){
	window.location = "login.cfm"
}

