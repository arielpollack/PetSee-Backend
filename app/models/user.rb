class User < ActiveRecord::Base
	has_many :reviews, :foreign_key => 'user_id'
	has_many :wrote_reviews, :class_name => 'Review', :foreign_key => 'writer_id'
end
