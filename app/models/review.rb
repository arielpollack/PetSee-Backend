class Review < ActiveRecord::Base
  belongs_to :user, :class_name => 'User'
  belongs_to :writer, :class_name => 'User'

  after_create :increase_user_rating
  after_update :update_user_rating

  def increase_user_rating
  	self.user.rating_count = self.user.rating_count + 1
  	self.user.rating = self.user.rating + (self.rate - self.user.rating) / self.user.rating_count
  	self.user.save!
  end

  def update_user_rating
  	return unless self.changed?
  	rating = self.user.rating - changed_attributes[:rate] / self.user.rating_count
  	self.user.rating = rating + (self.rate - rating) / self.user.rating_count
  	self.user.save!
  end
end
