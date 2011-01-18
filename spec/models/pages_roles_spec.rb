require 'spec_helper'

describe PagesRoles do

  before do
    @page = Page.create!(:title => 'I have no roles yet!')
    @role = Role.create!(:title => 'I have no pages yet!')
    @user = mock(User)
  end

  it "has empty arrays" do
    @page.roles.should == []
    @role.pages.should == []
  end

  it "allows access for nil user if the page has no roles" do
    @page.user_allowed?(nil).should == true
  end

  it "denies access for nil user if the page has roles" do
    @page.roles = [@role]
    @page.user_allowed?(nil).should == false
  end

  it "allows access for a page with no roles assigned" do
    @page.user_allowed?(@user)
  end

  it "denies access if page and user roles don't match" do
    @user.stub!(:roles).and_return([])
    @page.roles = [@role]
    @page.user_allowed?(@user).should == false
  end

  it "allows access if page and user roles match" do
    @user.stub!(:roles).and_return([@role])
    @page.roles = [@role]
    @page.user_allowed?(@user).should == true
  end

  it "has non-empty arrays" do
    PagesRoles.create!(:page_id => @page.id, :role_id => @role.id)
    @page.roles.length.should == 1
    @role.pages.length.should == 1

    @page.roles.first.id.should == @role.id
    @role.pages.first.id.should == @page.id
  end

end