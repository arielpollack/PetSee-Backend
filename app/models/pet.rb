class Pet < ActiveRecord::Base
  belongs_to :race
  belongs_to :owner, :class_name => 'Client', :foreign_key => 'owner_id'
end
