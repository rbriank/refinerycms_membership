@memberships
Feature: Memberships
  In order to have memberships on my website
  As an administrator
  I want to manage memberships

  Background:
    Given I am a logged in refinery user
    And I have no memberships

  @memberships-list @list
  Scenario: Memberships List
   Given I have memberships titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of memberships
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @memberships-valid @valid
  Scenario: Create Valid Membership
    When I go to the list of memberships
    And I follow "Add New Membership"
    And I fill in "Title" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 membership

  @memberships-invalid @invalid
  Scenario: Create Invalid Membership (without title)
    When I go to the list of memberships
    And I follow "Add New Membership"
    And I press "Save"
    Then I should see "Title can't be blank"
    And I should have 0 memberships

  @memberships-edit @edit
  Scenario: Edit Existing Membership
    Given I have memberships titled "A title"
    When I go to the list of memberships
    And I follow "Edit this membership" within ".actions"
    Then I fill in "Title" with "A different title"
    And I press "Save"
    Then I should see "'A different title' was successfully updated."
    And I should be on the list of memberships
    And I should not see "A title"

  @memberships-duplicate @duplicate
  Scenario: Create Duplicate Membership
    Given I only have memberships titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of memberships
    And I follow "Add New Membership"
    And I fill in "Title" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 memberships

  @memberships-delete @delete
  Scenario: Delete Membership
    Given I only have memberships titled UniqueTitleOne
    When I go to the list of memberships
    And I follow "Remove this membership forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 memberships
 