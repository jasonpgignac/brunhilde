
// This sets up the proper header for rails to understand the request type,
// and therefore properly respond to js requests (via respond_to block, for example)
// (Code borrowed from @andybenedetti at http://awesomeful.net/posts/47-sortable-lists-with-jquery-in-rails)

$(document).ready(function() {

	
  // UJS authenticity token fix: add the authenticy_token parameter
  // expected by any Rails POST request.
  $(document).ajaxSend(function(event, request, settings) {
    // do nothing if this is a GET request. Rails doesn't need
    // the authenticity token, and IE converts the request method
    // to POST, just because - with love from redmond.
    //if (settings.type == 'GET') return;
    //if (typeof(AUTH_TOKEN) == "undefined") return;
    //settings.data = settings.data || "";
    //settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
  });

});


// Retrieves JSON from a url, and returns the equivalent JS object
function getJSONResponseFrom(url) {
	return JSON.parse(jQuery.ajax({url: url, type: "GET", async: false}).responseText)
}

// Removes a nested row, particularly from the IV/IVR form
function remove_fields(link) {
	$(link).prev("input[type=hidden]").val("1");
	$(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g")
	$(link).next().css('background-color','red')
	//append(content.replace(regexp, new_id));
}