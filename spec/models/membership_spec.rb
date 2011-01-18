require 'spec_helper'

describe Membership do

  def reset_membership(options = {})
    @valid_attributes = {
      :id => 1,
      :title => "RSpec is great for testing too"
    }

    @membership.destroy! if @membership
    @membership = Membership.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_membership
  end

  context "validations" do
    
    it "rejects empty title" do
      Membership.new(@valid_attributes.merge(:title => "")).should_not be_valid
    end

    it "rejects non unique title" do
      # as one gets created before each spec by reset_membership
      Membership.new(@valid_attributes).should_not be_valid
    end
    
  end

end