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

private
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