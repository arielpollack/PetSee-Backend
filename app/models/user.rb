require 'securerandom'

class User < ActiveRecord::Base
	has_one :location
	has_many :reviews
	has_many :wrote_reviews, :class_name => 'Review', :foreign_key => 'writer_id'

	validates_uniqueness_of :email, :case_sensitive => false

	before_create :set_auth_token

	private
	def set_auth_token
		return if token.present?
		self.token = generate_auth_token
	end

	def generate_auth_token
		SecureRandom.uuid.gsub(/\-/,'')
	end
end
