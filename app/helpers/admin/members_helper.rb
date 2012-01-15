module Admin
  module MembersHelper
    
    def accept(member)
      link_to refinery_icon_tag('thumb_up.png') + t('accept', :scope => 'admin.members'), 
				accept_admin_member_path(member), 
				#:title => t('accept', :scope => 'admin.members'), 
				:class => 'action'
    end
    
    def reject(member)
      link_to refinery_icon_tag('thumb_down.png') + t('reject', :scope => 'admin.members'), 
				reject_admin_member_path(member), 
				#:title => t('reject', :scope => 'admin.members'), 
				:class => 'action'
    end
    
    
    def enable(member)
      link_to refinery_icon_tag('unlock.png') + t('enable', :scope => 'admin.members'), 
				enable_admin_member_path(member), 
				#:title => t('enable', :scope => 'admin.members'), 
				:class => 'action'      
    end
    
    def disable(member)
      link_to refinery_icon_tag('lock.png') + t('disable', :scope => 'admin.members'), 
				disable_admin_member_path(member), 
				#:title => t('disable', :scope => 'admin.members'), 
				:class => 'action'
    end
    
    def extend(member)
      link_to refinery_icon_tag('date_add.png') + t('extend', :scope => 'admin.members'), 
				extend_admin_member_path(member), 
				#:title => t('extend', :scope => 'admin.members'), 
				:class => 'action'
    end
    
    def edit(member)
      link_to refinery_icon_tag('application_edit.png') + t('edit', :scope => 'admin.members'), 
				edit_admin_member_path(member)#, 
				#:title => t('edit', :scope => 'admin.members')
    end
    
    def delete(member)
      link_to refinery_icon_tag('delete.png'), 
				admin_member_path(member),
        :class => "confirm-delete",
        :title => t('delete', :scope => 'admin.members'),
        :confirm => t('message', :scope => 'shared.admin.delete', :title => member.full_name),
        :method => :delete
    end
  end
end
