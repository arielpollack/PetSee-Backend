class Review < ActiveRecord::Base
  belongs_to :user, :class_name => 'User'
  belongs_to :writer, :class_name => 'User'

  after_create :update_user_rating

  def update_user_rating
  	self.user.rating_count = self.user.rating_count + 1
  	self.user.rating = self.user.rating + (self.rate - self.user.rating) / self.user.rating_count
  	self.user.save!
  end
end
