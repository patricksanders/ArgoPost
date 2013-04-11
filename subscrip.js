function createSubscription() {	
	//get thread title from the dropdown menu in the post UI
	var aThreadID = document.getElementById("threads");
	//get forum title from dropdown menu in the post UI
	var aForumTitle = document.getElementById("forums");
	
		$.ajax({
			type : "GET",
			url : "Subscriber.cfc?wsdl&method=AddToSubscriptions&ThreadID="+aThreadID.value,
			success : subscriptionSucceeded,
			failure : failedToAddSubscription
		});

}

function subscriptionSucceeded(response) {
	
	alert("Your subscription was successfully created!");
}

function failedToAddSubscription() {
	document.getElementById('addSubFailure').innerHTML = "*Subscription was not successfully created. Please try again."
	
}