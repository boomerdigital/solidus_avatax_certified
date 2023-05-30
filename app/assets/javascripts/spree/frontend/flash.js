window.show_flash = function(type, message) {
  var $addressValidator, $flashWrapper, flash_div;
  $addressValidator = $('.address_validator');
  $flashWrapper = $(".js-flash-wrapper");
  if (type === 'success') {
    $flashWrapper.find('.error.flash').hide();
    return $addressValidator.attr('disabled', true).text(message).addClass('flash success disabled');
  } else {
    if ($flashWrapper.length === 0) {
      $addressValidator.before("<div class=\"js-flash-wrapper\" />");
      $flashWrapper = $(".js-flash-wrapper");
    }
    $flashWrapper.empty();
    flash_div = $("<div class='flash " + type + "' />");
    $flashWrapper.prepend(flash_div);
    return flash_div.html(message).show();
  }
};
