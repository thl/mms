jQuery(document).ready(function(){
  /*=========== Side-Column ==========*/
  jQuery('#fxSideMenu').hide();
  jQuery("#sideMenuLink").css("background-position", "0% 0%");
  
  // When media popups are close, we need to reset the universal tabs' URLs to be not entity-specific
  jQuery('.thl-popup-close').live('click', function(){ universal_navigation.resetTabs(); });
});