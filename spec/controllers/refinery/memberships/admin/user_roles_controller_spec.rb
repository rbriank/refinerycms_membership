require 'spec_helper'

describe Admin::UserRolesController do
  include Devise::TestHelpers

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  def add_it(role_ids, item_ids)
    post 'create_multiple', :format => :json, :role_ids => [*role_ids], :item_ids => [*item_ids]
  end

  def delete_it(role_ids, item_ids)
    post 'destroy_multiple', :format => :json, :role_ids => [*role_ids], :item_ids => [*item_ids]
  end

  before do
    # this is required so we don't get redirected to the
    # 'create a first user' user
    Factory(:refinery_user)

    user = mock_user(:is_admin => true,
                     :authorized_plugins => [])

    # mock up an authentication in the underlying warden library
    request.env['warden'] = mock(Warden,:authenticate => user,
                                        :authenticate! => user,
                                        :authenticate? => true)
  end

  it 'should get the index' do
    get :index
    response.should be_success
  end

  describe 'adding roles to users' do

    before(:each) do
      @user = Factory(:user)
      @role = Role[:my_role]
    end

    it 'should add roles to the user' do
      add_it(@role.id, @user.id)
      @user.reload
      @user.role_ids.include?(@role.id).should == true
    end

    it 'should only add roles once' do
      add_it(@role.id, @user.id)
      add_it(@role.id, @user.id)
      @user.reload
      @user.role_ids.should == [@role.id]
    end

    it 'should not add to users that dont exist' do
      add_it(@role.id, 999)
      response.status.should == 500
    end

    it 'should not add roles that dont exist' do
      add_it(999, @user.id)
      response.status.should == 500
    end

    describe 'multiples' do
      before do
        @users = [Factory(:user),
          Factory(:user),
          Factory(:user)]
        @roles = [Role[:one_more_role], Role[:yet_another_role],
          Role[:please_no_more], Role[:ok_one_more]]
      end

      it 'should add many roles to one user' do
        add_it([@roles[0].id, @roles[1].id], @users[0].id)
        @users[0].reload
        @users[0].role_ids.should == [@roles[0].id, @roles[1].id]
      end

      it 'should add many roles to many users' do
        add_it([@roles[0].id, @roles[1].id], [@users[1].id, @users[2].id])
        @users[1].reload
        @users[1].role_ids.should == [@roles[0].id, @roles[1].id]
        @users[2].reload
        @users[2].role_ids.should == [@roles[0].id, @roles[1].id]
      end

      it 'should add one role to many users' do
        add_it(@roles[2].id, @users.map(&:id))
        @users.each{|user|
          user.reload
          user.role_ids.include?(@roles[2].id).should == true
        }
      end
    end # multiples
  end # adding roles to users

  describe 'deleting roles from users' do
    before do
      @users = [Factory(:user),
        Factory(:user),
        Factory(:user)]
      @roles = [Role[:my_role], Role[:role_heaven], Role[:monster_truck]]
      @users.each{|user| user.roles << @roles}
    end

    it 'should delete one role from one user' do
      delete_it(@roles[0].id, @users[0].id)
      @users[0].reload
      @users[0].roles.include?(@roles[0].id).should == false
    end

    it 'should delete many roles from one user' do
      delete_it(@roles.map(&:id), @users[1].id)
      @users[1].reload
      @users[1].roles.should == []
    end

    it 'should delete many roles from many users' do
      delete_it(@roles.map(&:id), @users.map(&:id))
      @users.each{|user|
        user.reload
        user.roles.should == []
      }
    end
  end # deleting roles from users

end