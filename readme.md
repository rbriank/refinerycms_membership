# Memberships engine for Refinery CMS.

__A role based membership engine for [refinerycms](http://refinerycms.com)__

## Installation

* Clone this repo into vendor/engines/refinerycms-memberships
* To your Gemfile add: 
* gem 'refinerycms-memberships', '1.0', :path => 'vendor/engines'
* Then run:
* bundle install
* rails generate refinerycms_events
* rake db:migrate
* Via the rails console, add a membership role:
* Role.create!(:id => 3, :title => 'Member')

## Notes

* You're a member or not, there are currently no different levels of membership
* I use jQuery [DataTable](http://www.datatables.net/index) to list members
* It integrates some page parts - you can chance them to fit your own needs

## Needs work

* Needs testing!  I had testing in the first version.  Sadly they are not updated.  Bad developer.. No cookie.
* Could have a role management piece
* Could have different levels of membership

## Versions

### 0.9.9.13
* Allows members to sign-up
* Admins can approve, reject, extend, cancel membership
* Members can log in, and reset their passwords
* No permission redirects to login instead of 404'ing
* Member's directory

### 0.9.9.8
* First version, just has page-role-user management
