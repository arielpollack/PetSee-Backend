json.array! @notifications do |notification|
    json.partial! 'notifications/notification', :notification => notification
end