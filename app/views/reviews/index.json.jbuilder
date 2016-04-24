json.reviews @reviews do |review|
	json.partial! 'reviews/review', :review => review
end
json.total @reviews.count
