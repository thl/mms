function ModelSearcher(){

	// URL for JSON that lists categories in the form [{"name":"Agricultrure","id":4074},{"name":"Agriculture","id":2558}]
	this.listService = "";
	
	// URL for JSON that lists categories in a hierachy (see ModelSearch.createTreeFromArray() for details)
	this.treeService = "";
	
	// A script on the same subdomain. When a URL is appended to this string, the resulting URL should return the original URL's content.
	// The proxy can be bypassed by using service URLs that don't begin with "http" (and are thus on the subdomain and don't need a proxy)
	this.proxy = "";
	
	// The id attribute of the div which contains all of DOM elements for this 
	this.divId = "";
	
	// The jQuery-wrapped DOM element of the div which contains all of DOM elements for this
	this.div = null;
	
	// The name, label, and style attributes of the hidden field in which the selected ID(s) will be entered
	this.fieldName = "searcher_id_input";
	this.fieldLabel = "";
	this.fieldStyle = "padding:3px";
	
	// Another method of adding objects (instead of using services)
	this.objectList = null;
	
	// A JS array of the object(s) which should be selected in the form [{id: '2594', name: 'animals'}]
	this.selectedObjects = null;
	
	// The jQuery-wrapped DOM element of the hidden input which stores the selected ID(s)
	this.hiddenIdInput = null;
	
	// The jQuery-wrapped DOM element of the autocomplete text field input
	this.autocompleteInput = null;
	
	// Whether or not a tree (and the accompanying tree link) should be used 
	this.hasTree = true;
	
	// Whether the user can select only one category from the tree (if present) or select multiple categories
	this.singleSelectionTree = false;
	
	// The id attribute of the div which contains the tree popup
	this.treePopupId = null;
	
	// The jQuery-wrapped DOM element of the div which contains the tree popup
	this.treePopup = null;
	
	// The jQuery-wrapped DOM element that lists the names selected from the tree
	this.treeNames = null;
	
	// The jQuery-wrapped DOM element that removes the names selected from the tree
	this.treeRemove = null;
	
	this.treeHtml = null;
	this.treeLoaded = false;
	
	this.cRowSelector = '#characteristic-row';
	this.bRowID = 'bin';
	this.binItemTemplate = '<span id="bin_item_{id}" class="tree-names" style="line-height:19px;white-space:nowrap;padding:2px 3px 2px 2px; color:#404040; background-color:#f1f1f1; border:1pt #ccc solid;margin-right:3px;font-size:7pt"><a href="#" class="tree-remove"><img src="/images/delete.png" height=16 width=16 border=0 alt="x" style="display:inline;position:relative;top:4px;left:-2px"/></a>{content}</span> ';
	
	// See the attribute documentation above for explanations of these arguments
	this.init = function(divId, listService, treeService, options){
		var that = this;

		this.listService = listService;
		this.treeService = treeService;
		if(typeof(options.fieldName) != "undefined")			{ this.fieldName = options.fieldName; }
		if(typeof(options.fieldLabel) != "undefined")			{ this.fieldLabel = options.fieldLabel; }
		if(typeof(options.selectedObjects) != "undefined")		{ this.selectedObjects = options.selectedObjects; }
		if(typeof(options.hasTree) != "undefined")				{ this.hasTree = options.hasTree; }
		if(typeof(options.singleSelectionTree) != "undefined")	{ this.singleSelectionTree = options.singleSelectionTree; }
		if(typeof(options.proxy) != "undefined")				{ this.proxy = options.proxy; }
		this.divId = divId;
		this.div = jQuery('#'+divId);
		this.autocompleteInput = jQuery('#searcher_autocomplete');
		this.hiddenIdInput = jQuery('#searcher_id_input');

		// Request the service through a proxy if it's not local
		if(this.listService.substr(0,4) == 'http'){
			this.listService = this.proxy+this.listService;
		}
		if(this.treeService.substr(0,4) == 'http'){
			this.treeService = this.proxy+this.treeService;
		}

		jQuery.getJSON(this.listService, function(data){
			that.autocompleteInput.unautocomplete().autocomplete(data, {
				matchContains: true,
				mustMatch: true,
				max: 20,
				formatItem: that.autocompleteFormatItem,
				formatMatch: that.autocompleteFormatMatch,
				formatResult: that.autocompleteFormatItem,
				multiple: true
			});
			that.autocompleteInput.result(that.autocompleteCallback);
			that.objectList = {};
			for(var i in data){
				that.objectList[data[i].id] = data[i];
			}
		});
		if(this.selectedObjects && this.selectedObjects.length == 1){
			this.autocompleteInput.val(this.selectedObjects[0].name);
			this.hiddenIdInput.val(this.selectedObjects[0].id);
		}
		if(this.hasTree){
			this.treePopupId = this.divId+"_model_searcher_tree_popup";
			this.treeLoading = this.div.find('.tree-loading');
		}
		
		jQuery('.tree-remove').unbind('click'); // this and below have to be separate because live can't be chained
		jQuery('.tree-remove').live('click', function(){
			var $selection = jQuery(this).closest('.tree-names'),
				$target = $selection.siblings().length ? $selection : $selection.closest('tr');
			
			$selection.fadeOut( function(){
				var id = this.id.replace('bin_item_',''),
					regex = new RegExp('(^|,)' + id + '(,|$)'),
					val = that.hiddenIdInput[0].value;
					
				$target.remove();	
				that.hiddenIdInput[0].value = val.replace(regex, ',');
				that.checkAnnotationState();
			});
			return false;
		});
		
		if ( document.getElementById('root_topics').value != 'All' ) jQuery('#browse_link').show().click(function(){that.activatePopup()});
	};
	
	this.activatePopup = function() {
		var thisModelSearcher = this;
		if(thisModelSearcher.treeLoaded){
			jQuery('#'+thisModelSearcher.treePopupId).show();
		}else{
			//thisModelSearcher.treeLoading.html(' <img src="../images/ajax-loader.gif" />');
			jQuery.getJSON(thisModelSearcher.treeService, function(data){
				thisModelSearcher.treeHtml = thisModelSearcher.createTreeFromArray(data.category ? data.category.categories : data.categories);
				thisModelSearcher.loadPopup();
				thisModelSearcher.treeHtml = null;
				data = null;
				//thisModelSearcher.treeLoading.html('');
				thisModelSearcher.treeLoaded = true;
			});
		}
		return false;
	}
	
	this.loadPopup = function(){
		var that = thisModelSearcher;
		that.treePopup = jQuery().draggablePopup({
			id: that.treePopupId,
			header: '',
			content: '',
			footer: '',
			width: 500,
			closeWith: 'hide'
		});
		var content = '<div style="font-size: 12px; line-height: 1.1em; height: 500px;"><br />'+
			'<div>Please select one or more feature types from the list below.<br /><br />'+
			'For each type, click on the left box to select the type and its subcategories; '+
			'click on the right box to select only the type without its subcategories.</div><br />'+
			'<form method="get" action="">'+
			'<div'+(that.singleSelectionTree ? ' class="single_selection_tree"' : '' )+
			' style="max-height: 400px; height:auto !important; height: 400px; overflow: auto;">'+
			that.treeHtml+
			'</div>'+
			'<br /><input type="submit" value="Select" /> <input type="button" value="Cancel" onclick="jQuery(this).parents(\'.draggable-popup:first\').hide(); return false;" />'+
			'</form>'+
			'</div>'
			;
		that.treePopup.setContent(content);
		that.treePopup.div.checkTree({ onExpand: function( $parent ) {$parent.siblings().find('.expanded').click()}});
		that.treePopup.div
			.find('form:first').submit(function(){
				var ids = [];

				jQuery(this).find(':checkbox:checked').each(function(){
					var label_name = jQuery(this).siblings('label').attr('name');
					if(label_name.indexOf('record_') == 0){
						ids.push(label_name.substring(7));
					}
				});
				if (ids.length) that.addValue( ids );
				jQuery('#'+that.treePopupId).hide();
				return false;
			});

		// For large trees, keeping this in memory can cause performance issues, so we'll set it to null
		// and use thisModelSearcher.treePopupId when we need it.
		that.treePopup = null;
	};
	
	this.addValue = function( ids ) {
		var that = thisModelSearcher,
			i,
			names = [],
			ids = ids || [],
			test = document.getElementById(that.bRowID),
			$bRow = test ? $(test) : jQuery("<tr><td></td><td colspan='2' style='padding-top:1px; padding-bottom:4px' id='" + that.bRowID + "'></td></tr>").insertAfter(jQuery(that.cRowSelector)).find('#' + that.bRowID);

		for(i in ids){
			if ( !document.getElementById('bin_item_' + ids[i]) ) {
				that.selectedObjects.push(that.objectList[ids[i]]);
				names.push(
					that.binItemTemplate
						.replace('{content}', that.objectList[ids[i]].name)
						.replace('{id}', ids[i])
				);
			}
		}
		that.hiddenIdInput[0].value += ',' + ids.join(',');
		$bRow.append(names.join(''));
		that.autocompleteInput.val('');
		this.checkAnnotationState();
	}
	
	this.checkAnnotationState = function() {
		if ( jQuery('.tree-names').length > 1 ) {
			jQuery('#media_category_association_string_value, #media_category_association_numeric_value').attr('disabled', 'disabled').closest('tr').fadeOut();
		} else {
			jQuery('.annotation').fadeIn().find('#media_category_association_string_value, #media_category_association_numeric_value').removeAttr('disabled');
		}
	}
	
	this.resetFields = function(){
		this.autocompleteInput.val('');
		this.hiddenIdInput.val('');
		if(this.hasTree){
			this.treeNames.html('');
			this.treeRemove.hide();
			jQuery('#'+this.treePopupId).hide();
		}
	};
	
	this.autocompleteFormatItem = function(item, i, max){
		return jQuery.trim(item.name);
	};
	
	this.autocompleteFormatMatch = function(item, i, max){
		return jQuery.trim(item.name);
	};
	
	this.autocompleteFormatResult = function(item, i, max){
		return item.id;
	};
	var thisModelSearcher = this;
	this.autocompleteCallback = function(event, data, formatted) {
		if(data){
			thisModelSearcher.addValue([data.id])
		}else{
			//thisModelSearcher.hiddenIdInput.val('');
		}
		
		//thisModelSearcher.treeNames.html('');
		// thisModelSearcher.treeRemove.hide();
		return false;
	};
	
	this.createTreeFromArray = function(arr){
		var html = '';
		if(arr && arr.category){
			html += '<ul class="tree">';
			if(arr.category && arr.category[0]){
				for(var i in arr.category) {
					html += '<li>';
					html += '<input type="checkbox" class="toggle"><label name="record_'+arr.category[i].id+'">'+arr.category[i].title+'</label>';
					if(arr.category[i].categories){
						html += this.createTreeFromArray(arr.category[i].categories);
					}
					html += '</li>';
				}
			}else if(arr.category){
				html += '<li>';
				html += '<input type="checkbox" class="toggle"><label name="record_'+arr.category.id+'">'+arr.category.title+'</label>';
				if(arr.category.categories){
					html += this.createTreeFromArray(arr.category.categories);
				}
				html += '</li>';
			}
			html += '</ul>';
		}
		return html;
	}

};

function reinit() {
	var el = document.getElementById('root_topics'),
		id = el.value,
		label = el.options[el.selectedIndex].text;		

	if ( id == 'All' ) {
		all_searcher();
	} else {
		searcher = new ModelSearcher();
		tmb_options['hasTree'] = true;
		tmb_options['fieldLabel'] = label;
		searcher.init( tmb_div, list_url.replace('{id}', id), all_url.replace('{id}', id), tmb_options);
	}
};