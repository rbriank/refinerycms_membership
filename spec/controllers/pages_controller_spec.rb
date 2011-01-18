require 'spec_helper'

describe PagesController, "check pages and user roles for permissibility" do
  before do
    @page = Page.create!(:title => 'my page')
    @page.roles << Role[:my_role]
    # ensure refinery user exists
    @refinery_user = Factory(:refinery_user)
    # mock our user
    @user = Factory(:user)
  end

  it "should 404 for invalid page/user role combination" do
    current_user = @user
    get :show, :id => @page.id
    response.status.should eql 404
  end

  it "should 200 for valid page/user role combination" do
    current_user = @user
    current_user.roles << Role[:my_role]
    get :show, :id => @page.id
    response.status.should eql 200
  end
end