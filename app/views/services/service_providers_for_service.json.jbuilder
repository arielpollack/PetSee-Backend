json.array! @providers do |provider|
	json.partial! 'users/user', :user => provider
end