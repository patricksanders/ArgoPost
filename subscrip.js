function createSubscription() {	
	//get thread title from the dropdown menu in the post UI
	var aThreadID = document.getElementById("threads");
	//get forum title from dropdown menu in the post UI
	var aForumTitle = document.getElementById("forums");
	
		$.ajax({
			type : "GET",
			url : "Subscriber.cfc?wsdl&method=AddToSubscriptions&ThreadID="+aThreadID.value,
			success : postSucceeded,
			failure : failedToAddPost
		});

}