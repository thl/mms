/*
thl plugin scripts -- jev3a@virginia.edu

depends on prototype.js, but not heavily

*/

var app = navigator.userAgent.match(/Firefox|Safari|MSIE|Opera?/i) ;
app = app[0] ;

// Boolean that reflects whether the page is inside a frame; used in the page's JS in case
// this state should affect the page's functionality  
var in_frame = false;

// object that handles bookmarking -- works only for IE and Firefox
var bookmarker = {
	label: "bookmark" ,		// text for the bookmark link
	title: document.title ,	// title for the bookmark
	omit: ["Safari"] ,		// browsers that don't support js bookmarking (may need to refine to allow for versions)
	
	init: function() {
		if ( this.markable( app ) ) {	// check to see if the useragent is eligible for bookmarking
			target = $('content') ;		// the element before which the bookmark link will be inserted
			container_dims = target.getDimensions() ;	// for placing the link on the right
			bm_html = "<div id=\"bookmark\" name=\"bookmark\" style=\"position: absolute; z-index: 1; top: 0px; left:" + 
			(container_dims.width - 80) + 
			"px\"><a href=\"javascript:void(bookmarker.set());\"><img src=\"../images/bookmark_add.png\" alt=\"bookmark\" width=\"14\" height=\"14\" border=\"0\" align=\"left\" />&nbsp;" + this.label + "</a></div>" ;
			target.insert( {before: bm_html} ) ; 
		}
	},
	
	// method to check if current user agent is eligible for bookmarking ( can't be done programatically )
	markable: function( app ) {
		omit_apps = this.omit.toString() ;
		if ( omit_apps.indexOf( app ) == -1 ) {
			return true ;
		}
		return false ;
	},
	
	// method called when user clicks the bookmark link
	set: function() {
		if ( app == "MSIE" ) {
			window.external.AddFavorite( bookmark_url , this.title ); 
		} else if ( app = "Firefox" ) {
			// add in note about sidebar bookmarks?
			window.sidebar.addPanel( this.title , bookmark_url , ""); 	// ff 3 has new way to do this, but haven't found js api yet	
		} else {														// for all other browsers, send proper link to parent hash and notify to bookmark regularly (class_external.js looks for &bookmark=true)
			loc = "iframe=" + window.location.href ;
			loc += ( window.location.href.indexOf("?") == -1 ) ? "?" : "" ;
			loc += "&bookmark=true&title=" + this.title  ;
			parent.location.hash = loc ;
		}
	}
	
}

var frame_service = {

	hide_stuff: function() {
		// this is necessary for ie6
		$('body').css({ 'padding': '0px' , 'backgroundImage': 'none' , 'backgroundColor': 'white' , 'textAlign': 'left' }) ;
		
		//$('unframe').hide() ; //TODO: change to look for .unframe so that an element can be given this class and be hidden automatically when in frame
	},
	
	// Based on the environment, get the appropriate hostname of the main THL site. 
	get_thl_hostname: function(){
		var service_hostname = window.location.hostname;
		if(service_hostname.indexOf('localhost') == 0){
			return 'localhost:90';
		}else if(service_hostname.indexOf('dev') == 0){
			return 'dev.thlib.org';
		}else{
			return 'www.thlib.org';
		}
	},
	
	// Set the height of the containing iframe.  Since cross-domain JS can't be used due to security constraints, we have to load
	// an iframe inside this iframe that has a PHP script from the same domain as the top window.  This script, when loaded will
	// call a function in the top window to resize the iframe to the specified height.
	set_iframe_height: function(){
		var iframe_height = $(document).height();
		$('#resize_iframe').remove();
		$('body').append('<iframe id="resize_iframe" src="http://'+this.get_thl_hostname()+'/global/php/resize_iframe.php?height='+iframe_height+'" height="0" width="0" style="display: none;"></iframe>');
		$('#resize_iframe').attr('src', $('#resize_iframe').attr('src'));
	},

	init: function() {
		//bookmarker.init() ;
		
		// If this isn't in an iframe, redirect to add a frame=destroy GET param to destroy the relevant session variable
		if(top==self){
			var loc = window.location;
			var separator = loc.search ? '&' : '?';
			window.location = loc.protocol+'//'+loc.host+loc.pathname+loc.search+separator+'frame=destroy'+loc.hash;
		}
		
		this.hide_stuff() ;
		this.set_iframe_height();
		$('#body-wrapper').css('width', '100%');
		
		// On AJAX success events, the height of the content might've changed, so we need to set the iframe height appropriately
		jQuery(document).ajaxSuccess(function(event, request, settings) {
			frame_service.set_iframe_height();
		});
		
		// For use in this application to determine alternate behavior when the app is in an iframe
		in_frame = true;
	}

}