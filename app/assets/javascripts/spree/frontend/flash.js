window.show_flash = function(type, message) {
  var addressValidator = document.querySelector('.address_validator');
  var flashWrapper = document.querySelector('.js-flash-wrapper');

  if (type === 'success') {
    if (flashWrapper) {
      var errorFlash = flashWrapper.querySelector('.error.flash');
      if (errorFlash) errorFlash.style.display = 'none';
    }
    if (addressValidator) {
      addressValidator.setAttribute('disabled', true);
      addressValidator.textContent = message;
      addressValidator.classList.add('flash', 'success', 'disabled');
    }
  } else {
    if (!flashWrapper) {
      flashWrapper = document.createElement('div');
      flashWrapper.className = 'js-flash-wrapper';
      if (addressValidator && addressValidator.parentNode) {
        addressValidator.parentNode.after(flashWrapper);
      } else {
        document.body.prepend(flashWrapper);
      }
    }
    flashWrapper.innerHTML = '';
    var flashDiv = document.createElement('div');
    flashDiv.className = 'flash ' + type;
    flashDiv.innerHTML = message;
    flashWrapper.prepend(flashDiv);
  }
};
