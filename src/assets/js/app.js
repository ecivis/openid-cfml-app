jQuery(function ($) {

	$("#authRequest button").on("click", function (event) {
		var promise, identifier = $("#identifier").val();
		
		event.preventDefault();
		
		if (!identifier.length) {
			$("#authRequest .control-group:first-child").addClass("error");
			return;
		}
		$("#authRequest .control-group:first-child").removeClass("error");
		
		promise = $.ajax("/authRequest.cfm", {
			type: "POST",
			dataType: "json",
			data: {identifier: identifier}			
		});
		promise.done(function (data, textStatus, jqXHR) {
			var authProceed = $("#authProceed"),
				template = authProceed.find(".template");

			if (data.method === "GET") {
				window.document.location = data.destinationUrl;
			} else {
				authProceed.attr("action", data.destinationUrl);
				$.each(data.parameters, function (key, value) {
					template.clone().attr({name: key, value: value}).appendTo(authProceed);
				});
				authProceed.submit();
			}
		});
	});

});
