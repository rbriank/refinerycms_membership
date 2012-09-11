module Refinery
  module Memberships
    class MembersController < ::ApplicationController

      # Protect these actions behind member login - do we need to check out not signing up when signed in?
      before_filter :redirect?, :except => [:new, :create, :login, :index, :welcome, :activate]

      before_filter :find_page, :except => [:activate, :login]

      # GET /member/:id
      def profile
        @member = current_refinery_user
      end

      def new
        @member = Member.new
      end

      # GET /members/:id/edit
      def edit
        @member = current_refinery_user
      end

      # PUT /members/:id
      def update
        @member = current_refinery_user

        if params[:member][:password].blank? and params[:member][:password_confirmation].blank?
          params[:member].delete(:password)
          params[:member].delete(:password_confirmation)
        end

        if @member.update_attributes(params[:member])
          flash[:notice] = t('successful', :scope => 'members.update', :email => @member.email)
          MembershipMailer.deliver_member_profile_updated(@member).deliver unless @member.has_role?(:admin)
          redirect_to profile_members_path
        else
          render :action => 'edit'
        end
      end

      def create
        @member = Member.new(params[:member])

        if @member.save
          MembershipMailer::deliver_member_created(@member)
          redirect_to welcome_members_path
        else
          @member.errors.delete(:username) # this is set to email
          render :action => :new
        end
      end

      def searching?
        params[:search].present?
      end

      def login
        find_page('/members/login')
      end

      def welcome
      end

      def activate
        find_page('/members/activate')
        resource = Member.confirm_by_token(params[:confirmation_token])

        if resource.errors.present?
          error_404
        end
      end

      private

    protected

      def redirect?
        if current_refinery_user.nil?
          redirect_to new_user_session_path
        end
      end

      def find_page(uri = nil)
        uri = uri ? uri : request.fullpath
        uri.gsub!(/\?.*/, '')
        @page = Page.find_by_link_url(uri, :include => [:parts])
      end
    end
  end
end
