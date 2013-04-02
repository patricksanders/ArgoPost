function createPost() {
	//get the title of the post
	var aTitle = document.getElementById("title");
	//get the description of the post
	var aDescription = document.getElementById("description");
	//get thread title from the dropdown menu in the post UI
	var aThreadTitle = document.getElementById("threads");
	//this variable is used to check if a field was left empty
	var isEmptyField = false;
	//check if a post description is longer than 255 characters. Can be removed if it determined this is not necessary
	var descriptionLength = getDescriptionLength(aDescription.value);
	

	//check if the title or description is null and set isError if needed
	if (isEmpty(title.value) === true || isEmpty(aDescription.value) === true) {
		isEmptyField = true;
	}

	//if there is an empty field send user back to post page with an error
	//explaining that all fields must be completed
	if (isEmptyField === true) {
		console.log("You must complete all fields");
		//still need to fill out the rest of this block
		writeError();
	} 
	else if(descriptionLength === true){
		console.log("Post is too long.");
		//write error message to page telling user the post is too long
	}
	else {
		$.ajax({
			type : "GET",
			url : "http://localhost:8500/argoPost/Post.cfc?wsdl&method=addPost&postTitle="+aTitle.value+"&postContent="+aDescription.value+"&threadTitle="+aThreadTitle.value,
			contentType : "application/json; charset=utf-8",
			dataType : "json",
			success : succeeded,
			failure : failedToAddPost
		});
	}
}

/**
 * once a post has been successfully added the first thing that needs to be done is notify all subscribers
 * of that thread that the post was created. The next action will be to direct the user to the newly created post.
 */
function succeeded(response) {
	//notify subscribers
	//redirect the user to the post they just made
	console.log("succeeded: " + response);
}

/**
 * This function will run if there is an error adding a post to the database.
 */
function failedToAddPost() {
	//this function should send the user back to the create post page and alert them that there was a problem adding the post to the db
	console.log("failed");
}

/**
 * This function checks if a field has been left empty and returns true or false accordingly
 */
function isEmpty(value) {
	if (value == null || value.length <= 0 || value === undefined) {
		return true;
	}
	return false;
}

/**
 * This function returns whether or not a post description is longer than 255 characters 
 */
function getDescriptionLength(desc){
	console.log(desc.length);
	if(desc.length > 255)
	{
		return true
	}
	return false
}

/**
 *This function is used to alert the user that a field has been left empty. 
 */
function writeError(){
	
}

/**
 *This function will run when the create post page is loaded. It will fill the Forums drop down menu with the list of forum titles.
 */
function getForumTitles() {

}

/**
 *This function will run once the user has selected a Forum in the drop down menu. It will fill the Threads drop down menu with all the threads in the
 * forum that the user has selected.
 */
function getThreadTitles() {

}
