class Admin::MembershipsController < Admin::BaseController

  # POST /refinery/*_roles/create_multiple.json
  def create_multiple
    parse_roles(params) do |items, roles|
      items.each{|item| item.roles << [roles - item.roles]} unless items.nil? || roles.nil?
    end
  end

  # POST /refinery/*_roles/destroy_multiple.json
  def destroy_multiple
    parse_roles(params) do |items, roles|
      items.each{|item| item.roles.delete(roles) } unless items.nil? || roles.nil?
    end
  end

  def index
    respond_to do |format|
      format.html { 
       
      }
      format.js{ 
        @objects = current_objects(params)
        @total_objects = total_objects(params)
        render :layout => false
      }
    end
  end
  
private
  def current_objects(params={})
    current_page = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0)+1
    @current_objects = Member.paginate :page => current_page,
      :include => :roles,
      :order => "#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}",
      :conditions => conditions,
      :per_page => params[:iDisplayLength]
  end

  def total_objects(params={})
    @total_objects = Member.count :conditions => conditions
  end

  def datatable_columns(column_id)
    case column_id.to_i
    when 0
      return "last_name"
    when 1
      return "organization"
    when 2
      return "email"
    when 3
      return "created_at"
    when 4
      return "paid_until"
    else
      return "last_name"
    end

  end

  def conditions
    conditions = []
    conditions << %Q(
        first_name LIKE '%#{params[:sSearch]}%' OR
        last_name LIKE '%#{params[:sSearch]}%' OR
        organization LIKE '%#{params[:sSearch]}%'OR
        email LIKE '%#{params[:sSearch]}%'
    ) unless params[:sSearch].blank?
    
    return conditions.join(" AND ")
  end

  def respond_to_json(&block)
    respond_to do |format|
      format.json {
        begin
          block.call
          render :text => '', :status => 200

        rescue Exception => e
          render :text => e.message, :status => 500

        end
      }
    end
  end

  def parse_roles(params, &block)
    respond_to_json do
      items = get_items(params)
      roles = Role.find(params[:role_ids])

      block.call(items, roles) unless items.blank? || roles.blank?
    end
  end

  # this wants a params[:controller] =~ '[admin/]#{kind}_roles'
  def get_items(params)
    kind = get_kind(params)
    klass = kind.camelize.constantize
    klass.find(params[:item_ids], :include => :roles) unless params[:item_ids].nil?
  end

  def get_kind(params)
    name = params["controller"] || params[:controller]
    name.split('/')[-1].split('_')[0]
  end

end