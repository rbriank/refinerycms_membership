# make users and members two different classes
::Refiner::User.class_eval do
  set_inheritance_column :membership_level
end
