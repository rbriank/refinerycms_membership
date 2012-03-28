$(function(){
  $('#dialog_menu_left input[type="radio"]').change(function(){
    $('.dialog_area').hide();
    $('#'+$(this).val())[$(this).is(':checked') ? 'show' : 'hide']();
  });
  
  $('.form-actions-dialog #cancel_button').not('.wym_iframe_body .form-actions-dialog #cancel_button').click(close_dialog);
  
});