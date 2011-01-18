Given /^I have no memberships$/ do
  Membership.delete_all
end

Given /^I (only )?have memberships titled "?([^"]*)"?$/ do |only, titles|
  Membership.delete_all if only
  titles.split(', ').each do |title|
    Membership.create(:title => title)
  end
end

Then /^I should have ([0-9]+) memberships?$/ do |count|
  Membership.count.should == count.to_i
end
