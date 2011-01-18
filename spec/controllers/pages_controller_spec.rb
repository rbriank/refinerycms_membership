require 'spec_helper'

describe PagesController, "check pages and user roles for permissibility" do
  before do
    @page = Page.create!(:title => 'my page')
    @role = Role.create!(:title => 'my role')
    @page.roles << @role
    @user = mock(User)
  end

  it "should 404 for invalid page/user role combination" do
    current_user = @user.stub(:roles).and_return([])
    get :show, :id => @page.id
    response.status.should eql 404
  end

  it "should 200 for valid page/user role combination" do
    current_user = @user.stub(:roles).and_return([@role])
    get :show, :id => @page.id
    response.status.should eql 200
  end
end