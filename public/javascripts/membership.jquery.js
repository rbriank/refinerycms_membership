
(function($){
  // redefine slideTo to init slickGrid before sliding
  $.fn.slideTo = function(response) {
    $(this).html(response);
    $("#members").slickGrid();
    $(this).applyMinimumHeightFromChildren();
    $(this).find('.pagination_frame').removeClass('frame_right').addClass('frame_center');
    init_modal_dialogs();
    init_tooltips();
    return $(this);  
  };

  $.fn.slickGrid = function(o){
    var table = this;
    var columns = this.columns = [];
    var widths = this._loadColumnsWidths();
    $(table).find('thead th').each(function(idx, th){
      var id = null;
      columns.push({
        name: $(th).html(), 
        field: (id = Math.round(Math.random()*100000).toString()), 
        id: id,
        width: widths[idx],
        sortable: true
      });
    });
    columns[columns.length - 1].resizable = false;
    delete columns[columns.length - 1].width;
    delete columns[columns.length - 1].sortable;
    var data = []
    $(table).find('tbody tr').each(function(idx, tr){
      var row = {};
      $(tr).find('td').each(function(idx1, td){
        row[columns[idx1].id] = $(td).html();
      });
      data.push(row);
    });
    var opts = {
			enableCellNavigation: true,
      enableColumnReorder: false,
      autoHeight: true,
      forceFitColumns: true,
      rowHeight: 35,
      headerRowHeight: 35
    };
    $(this).wrap('<div></div>');
    $(this).parent().addClass('slick-grid').css({width: $(this).width()});
    var grid = new Slick.Grid($(this).parent().get(0), data, columns, opts);
    var self = this;
    grid.onSort.subscribe(function(){self._onSort.apply(self, arguments)});
    grid.onColumnsResized.subscribe(function(){self._onColumnsResize.apply(self, arguments)});
  
    var sort = this._getSortInfo();

    grid.setSortColumn(columns[sort[0]||0].id, sort[1] == 'asc');
    
    $(this).parent().show();
    init_tooltips();

    return $(this);
  };
  
  $.fn._onColumnsResize = function(ev, grid){
    var columns = grid.grid.getColumns();
    var widths = [];
    for(var n = 0; n < columns.length; n++){
      widths.push(columns[n].width);
    }
    this._saveColumnsWidths(widths);
  };
  
  $.fn._saveColumnsWidths = function(ary){
    var str = '[' + (ary||[]).join(',') + ']';
    $.cookie('membership_column_widths', str, {expires: 10000, path: '/'});
  };
  
  $.fn._loadColumnsWidths = function(){
    var str = $.cookie('membership_column_widths', {path: '/'}) || '[]';
    return $.parseJSON(str);
  };
  
  $.fn._onSort = function(ev, obj){
    var dir = obj.sortAsc ? 'asc' : 'desc';
    var col = obj.grid.getColumnIndex(obj.sortCol.id);
    var url = this._updateUrlParams({order_by: col, order_dir: dir});
    if(typeof(window.history.pushState) == 'function') {
      var current_state_location = (location.pathname + location.href.split(location.pathname)[1]);
      window.history.pushState({
        path: current_state_location
      }, '', url);
      $(document).paginateTo(url);
    } else {
      window.location = url;
    }
  };
  
  $.fn._getSortInfo = function(){
    var params = this._getUrlParams();
    return [parseInt(params.order_by || 0), (params.order_dir || 'asc').toLowerCase()];
  };

  $.fn._getUrlParams = function(){
    var url = window.location.toString();
    var params = {};
    var args = url.split('?')[1].split('&');
    for(var n = 0; n < args.length; n++){
      var arg = args[n].split('=');
      params[arg[0]] = arg[1];
    }
    return params;
  };

  $.fn._updateUrlParams = function(new_params){
    var url = window.location.toString().replace(/\?.*$/, '');
    var params = this._getUrlParams();
    new_params = new_params || {};
    for(k in new_params){
      params[k] = new_params[k];
    }
    return url + '?' + $.param(params);
  };
})(jQuery);