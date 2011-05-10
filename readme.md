# Memberships engine for Refinery CMS.

__A role based membership engine for [refinerycms](http://refinerycms.com)__

## Installation

* Clone this repo into vendor/engines/refinerycms-memberships
* To your Gemfile add: 
* gem 'refinerycms-memberships', '1.0', :path => 'vendor/engines'
* Then run:
* bundle install
* rails generate refinerycms_memberships
* rake db:migrate
* Via the rails console, add a membership role:
* Role.create!(:id => 3, :title => 'Member')

 * set up actionmailer in your environment file(s) the plugin will fail without it

*  config.action_mailer.raise_delivery_errors = false
*  config.action_mailer.delivery_method = :sendmail
*  config.action_mailer.perform_deliveries = true
*  config.action_mailer.raise_delivery_errors = true
*  config.action_mailer.default_url_options = { :host => "some.host.com" }

* Define ADMIN_EMAIL constant. This will be the "from" when users get email.



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
