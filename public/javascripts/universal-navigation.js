function UniversalNavigation(){

	// The id attribute of the div which contains all of DOM elements for this 
	this.divId = "";
	
	// The jQuery-wrapped DOM element of the div which contains all of DOM elements for this
	this.div = null;
	
	this.tabs = [];
	
	this.tabUrls = {};

	// See the attribute documentation above for explanations of these arguments
	this.init = function(divId, options){
		if(options.selectedIndex)			{ this.selectedIndex = options.selectedIndex; }
		if(options.selectedTabId)			{ this.selectedTabId = options.selectedTabId; }
		if(options.tabs)					{ this.tabs = options.tabs; }
		this.divId = divId;
		this.div = jQuery('#'+divId);
		jQuery('#'+this.divId).tabs({
			selected: this.selectedIndex,
			select: function(event, ui) {
				var url = jQuery.data(ui.tab, 'load.tabs');
				if(url) {
					window.location = url;
					return false;
				}
				return true;
			}
      	});
      	jQuery('#'+this.divId+' > ul.ui-tabs-nav > li > a').each(function(index){
      		var url = jQuery.data(this, 'href.tabs');
      		jQuery(this).attr('href', url);
      	});
	}
	
	this.setTabUrl = function(tab_id, url){
		var index = this.getTabIndexById(tab_id);
		jQuery('#'+this.divId).tabs('url', index, url);
	}
	
	this.getTabIndexById = function(tab_id){
		var index = 0;
		for(var i in this.tabs){
			if(this.tabs[i].id == tab_id){
				return index;
			}
			index++;
		}
		return false;
	}
	
	this.getTabById = function(tab_id){
		for(var i in this.tabs){
			if(this.tabs[i].id == tab_id){
				return this.tabs[i];
			}
		}
		return false;
	}
	
	this.loadTabsFor = function(id){
		var tab = this.getTabById(this.selectedTabId);
		for(var tab_id in tab.tabs){
			var url = tab.tabs[tab_id].url.replace(':id', id);
			this.setTabUrl(tab_id, url);
		}
		return false;
	}
	
	this.initSecondaryTabs = function(options){
		if(typeof options.selectedIndex != 'undefined')		{ this.selectedIndex = options.selectedIndex; }
		var tab_options = {
			select: function(event, ui) {
				var url = $.data(ui.tab, 'load.tabs');
				if( url ) {
					location.href = url;
					return false;
				}
				return true;
			}
		};
		if(typeof this.selectedIndex != 'undefined'){
			tab_options['selected'] = this.selectedIndex;
		}
		jQuery('#'+this.divId+' .secondary-universal-navigation').tabs(tab_options);
		
      	jQuery('#'+this.divId+' .secondary-universal-navigation > ul.ui-tabs-nav > li > a').each(function(index){
      		var url = jQuery.data(this, 'href.tabs');
      		jQuery(this).attr('href', url);
      	});
	}

};