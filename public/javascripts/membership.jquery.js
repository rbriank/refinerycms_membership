if(!jQuery){
  alert("jQuery is missing.  Your changes won't be saved!");
} else {  
  
  // ajax calls for add/del roles
  function onRoleChange(controller, item_ids, role_ids, method){

    $.ajax({
      type: method,
      url: '/refinery/' + controller + '.json',
      data: {
        item_ids : item_ids,
        role_ids : role_ids
      },
      dataType: 'json',
      beforeSend: function(){
        $('#loading').show();
      },
      complete: function(msg) {
        $('#loading').hide();
      },
      error: function(msg) {
        alert("Well that didn't work!\n" + msg);
      }
    });

  }
}