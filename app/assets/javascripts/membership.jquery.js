if(!jQuery){
  alert("jQuery is missing.  Your changes won't be saved!");
} else {
  
  // wire up check boxes
  $('#page-roles-table :checkbox').live('change', function(){
    var controller = 'page_roles' //$(this).closest('table')[0].id;
    var values = this.value.split('_');
    var action = this.checked ? '/create_multiple' : '/destroy_multiple'
    
    onRoleChange(controller + action, [values[1]], [values[3]], 'POST');
  });
  
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