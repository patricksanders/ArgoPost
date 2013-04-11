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