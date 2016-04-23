class ServiceProviderSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :service_provider
end
