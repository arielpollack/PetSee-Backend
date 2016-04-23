class User < ActiveRecord::Base
	has_one :location
	has_many :reviews
	has_many :wrote_reviews, :class_name => 'Review', :foreign_key => 'writer_id'
end
