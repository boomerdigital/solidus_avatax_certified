$.fn.usecodeAutocomplete = function () {
  'use strict';

  this.select2({
    minimumInputLength: 1,
    multiple: false,
    initSelection: function (element, callback) {
      Spree.ajax({
        url: Spree.pathFor("admin/avalara_entity_use_codes"),
        data: {
          ids: element.val()
        },
        success: function(data) {
          callback(data[0]);
        }
      })
    },
    ajax: {
      url: Spree.pathFor("admin/avalara_entity_use_codes"),
      datatype: 'json',
      data:  function (term) {
        return {
          q: term
        };
      },
      results: function (data) {
        return {
          results: data
        };
      }
    },
    formatResult: function (use_codes) {
      if( !use_codes.use_code ){
        return "Enter Avalara Entity Use Code"
      } else {
        return use_codes.use_code + ') Description: ' + use_codes.use_code_description;
      }
    },
    formatSelection: function (use_codes) {
      if( !use_codes.use_code ){
        return "Enter Avalara Entity Use Code"
      } else {
        return use_codes.use_code + ') Description: ' + use_codes.use_code_description;
      }
    }
  });
};

$(document).ready(function () {
  $('.use_code_picker').usecodeAutocomplete();
});
