WYMeditor.INIT_DIALOG_overridenByRottame = WYMeditor.INIT_DIALOG;

WYMeditor.INIT_DIALOG = function(wym, selected, isIframe) {
  
  if (wym._selected_image) {
    var replaceable = $(wym._selected_image);
  } else {
    var replaceable = $(wym._doc.body).find('#' + wym._current_unique_stamp);
  }

  var fn = function(e) {
    form = $(this.form);
    if ((url = form.find(wym._options.srcSelector).val()) != null && url.length > 0) {
      (image = $(wym._doc.createElement("IMG")))
        .attr(WYMeditor.SRC, url)
        .attr(WYMeditor.TITLE, form.find(wym._options.titleSelector).val())
        .attr(WYMeditor.ALT, form.find(wym._options.titleSelector).val())
        .attr(WYMeditor.REL, form.find(wym._options.sizeSelector).val())
        .attr('data-id', form.find('.wym_image_id').val())
        .attr('data-size', form.find('.wym_data_size').val())
        .load(function(e){
          $(this).attr({
            'width': $(this).width()
            , 'height': $(this).height()
          });
        });

       // ensure we know where to put the image.
       if (replaceable == null) {
         replaceable = $(wym._doc.body).find("#" + wym._current_unique_stamp);
       }
       if (replaceable != null) {
         replaceable.after(image).remove();
       }

      // fire a click event on the dialogs close button
      wym.close_dialog(e);
    } else {
      // remove any save loader animations.
      $('iframe').contents().find('.save-loader').remove();
      // tell the user.
      alert("Please select an image to insert.");
    }
    e.preventDefault();
  };
  
  var submit = $(wym._options.dialogImageSelector).find(wym._options.submitSelector);
  if(submit.get(0)) {
    // get all the handlers for click event and store the number of attached handlers
    var handlers = submit.data('events');
    var handlersCount = 0;
    if(handlers && handlers.click){
      handlersCount = handlers.click.length;
    }
    
    WYMeditor.INIT_DIALOG_overridenByRottame(wym, selected, isIframe);
    
    // the function to execute on click
  
    // check if a new hander was attached and override it
    handlers = submit.data('events');
    
    if(handlers && handlers.click && handlersCount < handlers.click.length){
      // ok, unbind the handler
      submit.unbind('click', handlers.click[handlers.click.length - 1].handler);
    }
    //bind overriden handler
    submit.click(fn);
  } else {
    // not the dialog I'm interested
    WYMeditor.INIT_DIALOG_overridenByRottame(wym, selected, isIframe);
  }
};

image_dialog.set_image_overriden_by_rottame = image_dialog.set_image;
image_dialog.set_image = function(img){
  image_dialog.set_image_overriden_by_rottame(img);
  if ($(img).length > 0) {

    var imageId = $(img).attr('data-id');
    var size = $('#existing_image_size_area li.selected a').attr('data-size');
    var resize = $("#wants_to_resize_image").is(':checked');

    if (parent) {
      if ((wym_image_id = parent.document.getElementById('wym_image_id')) != null) {
        wym_image_id.value = imageId;
      }
      if ((wym_data_size = parent.document.getElementById('wym_data_size')) != null) {
        wym_data_size.value = resize ? size : 'original';
      }
    }
  }
}

