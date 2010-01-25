// This file is automatically included by javascript_include_tag :defaults
if (window.addEventListener) {
  window.addEventListener("load", animate_flash, false);
} else if (window.attachEvent) {
  window.attachEvent("onload", animate_flash);
} else {
  window.onload = animate_flash;
}

function animate_flash() {
  if ($('flash_error') != null) {
    $('flash_error').hide();
    $('flash_error').slideDown();
    $('flash_error').slideUp({delay: 3.0, queue: 'end'});
  } else if ($('flash_notice') != null) {
    $('flash_notice').hide();
    $('flash_notice').slideDown();
    $('flash_notice').slideUp({delay: 3.0, queue: 'end'});
  }

  var e = $A(document.getElementsByTagName('*')).find(function(e) {
      return (e.tagName.toUpperCase() == 'INPUT' && (e.type == 'text' || e.type == 'password'))
      || e.tagName.toUpperCase() == 'TEXTAREA' || e.tagName.toUpperCase() == 'SELECT';
    });
  if (e) e.focus();

}
