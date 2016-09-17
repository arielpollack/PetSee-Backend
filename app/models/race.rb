class Race < ActiveRecord::Base
	has_many :pets, :foreign_key => 'race_id'
	validates_uniqueness_of :name, :case_sensitive => false
end
