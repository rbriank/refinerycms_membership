# Memberships engine for Refinery CMS.

__A role based membership engine for [refinerycms](http://refinerycms.com)__

## Installation

* To your Gemfile add: 
	* gem 'refinerycms-memberships', '2.0'
* Then run:
	* bundle install
	* rails generate refinery:memberships
	* rake db:migrate

* set up actionmailer in your environment file(s) the plugin will fail without it
 *  config.action_mailer.raise_delivery_errors = false
 *  config.action_mailer.delivery_method = :sendmail
 *  config.action_mailer.perform_deliveries = true
 *  config.action_mailer.default_url_options = { :host => "some.host.com" }

* In config/initializers/refinery/memberships.rb
 * Define admin_email config option. This will be the "from" when users get email.
 * Define new_user_path with a path, like '/login/new', if you want to change the login page. You will have to create a controller, view and route for that page.
 
* In config/initializers/refinery/authentication.rb
 * Enable superuser_can_assign_roles if you want to create members from users tab.

## Notes

* You're a member or not, there are currently no different levels of membership
* I use jQuery [DataTable](http://www.datatables.net/index) to list members
* It integrates some page parts - you can chance them to fit your own needs

## Needs work

* Needs testing!  I had testing in the first version.  Sadly they are not updated.  Bad developer.. No cookie.
* Could have a role management piece
* Could have different levels of membership

## Versions

### 2.0
* Add configuration for login page route.
* Update to refinerycms 2.0

### 0.9.9.13
* Allows members to sign-up
* Admins can approve, reject, extend, cancel membership
* Members can log in, and reset their passwords
* No permission redirects to login instead of 404'ing
* Member's directory

### 0.9.9.8
* First version, just has page-role-user management
