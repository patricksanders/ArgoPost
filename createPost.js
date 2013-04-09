function createPost() {
	//get the title of the post
	var aTitle = document.getElementById("title");
	//get the description of the post
	var aDescription = document.getElementById("description");
	//get thread title from the dropdown menu in the post UI
	var aThreadID = document.getElementById("threads");
	//get forum title from dropdown menu in the post UI
	var aForumTitle = document.getElementById("forums");
	//this variable is used to check if a field was left empty
	var isEmptyField = false;
	
	//check if the title or description is null and set isError if needed
	if (isEmpty(title.value) === true || isEmpty(aDescription.value) === true) {
		isEmptyField = true;
	}
	
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
		writeFormError(document.aPost);
	} 
	else {
		$.ajax({
			type : "GET",
			url : "Post.cfc?wsdl&method=addPost&postTitle="+aTitle.value+"&postContent="+aDescription.value+"&threadID="+aThreadID.value,
			contentType : "application/json; charset=utf-8",
			dataType : "json",
			success : postSucceeded,
			failure : failedToAddPost
		});
	}
}

/**
 * once a post has been successfully added the first thing that needs to be done is notify all subscribers
 * of that thread that the post was created. The next action will be to direct the user to the newly created post.
 */
function postSucceeded(response) {
	//redirect the user to the post they just made -  not exaclty sure how to do this
	var aThreadID = document.getElementById("threads");
	window.location = "main.html";
}

/**
 * This function will run if there is an error adding a post to the database.
 */
function failedToAddPost() {
	document.getElementById('addPostFailure').innerHTML = "*Post was not successfully created. Please try again."
	
}


 /** This function checks if a field has been left empty and returns true or false accordingly */
function isEmpty(value) {
	if (value == null || value.length <= 0 || value === undefined) {
		return true;
	}
	return false;
}


/**
 *This function is used to alert the user that a field has been left empty. 
 */
function writeFormError(form1){
	document.getElementById('titleErrorMsg').innerHTML = "";
	document.getElementById('descriptionErrorMsg').innerHTML = "";
	document.getElementById('threadsErrorMsg').innerHTML = "";
	document.getElementById('forumsErrorMsg').innerHTML = "";
	
	if(form1.title.value==""){
		document.getElementById('titleErrorMsg').innerHTML = "*Please enter a title.";
	}
	
	if(form1.description.value==""){
		document.getElementById('descriptionErrorMsg').innerHTML = "*Please enter a description.";
	}
	
	if(form1.threads.value=="Select a thread"){
		document.getElementById('threadsErrorMsg').innerHTML = "*Please select a thread.";
	}
	
	if(form1.forums.value=="Select a forum"){
		document.getElementById('forumsErrorMsg').innerHTML = "*Please select a forum.";
	}
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
	}
	else{
		window.location = "login.html";
	}
}

/**
 * What to do if checking the users logged in status has failed. 
 */
function loggedInStatusFailed(){
	window.location = "login.html"
}
