require 'spec_helper'

describe Admin::PageRolesController do
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
    # 'create a first user' page
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

  describe 'adding roles to pages' do

    before do
      @page = Page.create!(:title => 'My page')
      @role = Role[:my_role]
    end

    it 'should add roles to the page' do
      add_it(@role.id, @page.id)
      @page.reload
      @page.role_ids.include?(@role.id).should == true
    end

    it 'should only add roles once' do
      add_it(@role.id, @page.id)
      add_it(@role.id, @page.id)
      @page.reload
      @page.role_ids.should == [@role.id]
    end

    it 'should not add to pages that dont exist' do
      add_it(@role.id, 999)
      response.status.should == 500
    end

    it 'should not add roles that dont exist' do
      add_it(999, @page.id)
      response.status.should == 500
    end

    describe 'multiples' do
      before do
        @pages = [Page.create!(:title => 'another one'),
          Page.create!(:title => 'and another'),
          Page.create!(:title => 'and the last')]
        @roles = [Role[:one_more_role], Role[:yet_another_role],
          Role[:please_no_more], Role[:ok_one_more]]
      end

      it 'should add many roles to one page' do
        add_it([@roles[0].id, @roles[1].id], @pages[0].id)
        @pages[0].reload
        @pages[0].role_ids.should == [@roles[0].id, @roles[1].id]
      end

      it 'should add many roles to many pages' do
        add_it([@roles[0].id, @roles[1].id], [@pages[1].id, @pages[2].id])
        @pages[1].reload
        @pages[1].role_ids.should == [@roles[0].id, @roles[1].id]
        @pages[2].reload
        @pages[2].role_ids.should == [@roles[0].id, @roles[1].id]
      end

      it 'should add one role to many pages' do
        add_it(@roles[2].id, @pages.map(&:id))
        @pages.each{|page|
          page.reload
          page.role_ids.include?(@roles[2].id).should == true
        }
      end
    end # multiples
  end # adding roles to pages

  describe 'deleting roles from pages' do
    before do
      @pages = [Page.create!(:title => 'My page'),
        Page.create!(:title => 'another page'),
        Page.create!(:title => 'wow - still more')]
      @roles = [Role[:my_role], Role[:role_heaven], Role[:monster_truck]]
      @pages.each{|page| page.roles << @roles}
    end

    it 'should delete one role from one page' do
      delete_it(@roles[0].id, @pages[0].id)
      @pages[0].reload
      @pages[0].roles.include?(@roles[0].id).should == false
    end

    it 'should delete many roles from one page' do
      delete_it(@roles.map(&:id), @pages[1].id)
      @pages[1].reload
      @pages[1].roles.should == []
    end

    it 'should delete many roles from many pages' do
      delete_it(@roles.map(&:id), @pages.map(&:id))
      @pages.each{|page|
        page.reload
        page.roles.should == []
      }
    end
  end # deleting roles from pages

end