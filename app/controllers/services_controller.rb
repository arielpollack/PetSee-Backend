require 'date'

class ServicesController < ApplicationController
    before_action :authenticate

    def index
        if @current_user.instance_of?(Client)
            @services = Service.includes(:pet, :service_provider).where(client_id: @current_user.id)
            @with_client = false
            @with_service_provider = true
        elsif @current_user.instance_of?(ServiceProvider)
            @services = Service.includes(:pet, :client).where(service_provider_id: @current_user.id)
            @with_client = true
            @with_service_provider = true
        end
    end


    # Create new service by client (3-way handshake - part #1)
    def create
        # Validate permissions
        return unless permitted_for_user_type?(Client)

        # Extract params
        render_not_found 'missing pet_id' and return false unless (pet_id = params[:pet_id])
        render_not_found "couldn't find pet with id #{pet_id}" and return false unless (pet = Pet.find_by_id(pet_id))
        render_not_found 'missing time_start' and return false unless (time_start = params[:time_start])
        render_not_found 'missing time_end' and return false unless (time_end = params[:time_end])
        render_not_found "location is missing" and return unless params[:lat].present? and params[:lng].present?

        # Validate params
        render_bad_request 'start time is after end time' and return false if time_start.to_i > time_end.to_i
        render_forbidden "this is not your pet" and return if pet.owner.id != @current_user.id

        # Create new service object
        new_service = {}
        new_service[:client_id] = @current_user.id
        new_service[:pet_id] = params[:pet_id]
        new_service[:type] = params[:type]
        new_service[:time_start] = parse_time(time_start)
        new_service[:time_end] = parse_time(time_end)

        # generate location for service
        location = Location.new({:latitude => params[:lat], :longitude => params[:lng], :street_address => params[:address]})
        render_unprocessable_entity "couldn't save location" and return unless location.save
        new_service[:location_id] = location.id

        @with_client = true
        @with_service_provider = false

        # create&save new service active record
        service = Service.new(new_service)
        if service.save
            render 'services/_service', :locals => {:service => service}
        else
            render :json => {:has_errors => true, :errors => service.errors}, :status => :unprocessable_entity
        end
    end


    def requests
        # Retrieve service
        return unless get_service?
        @with_provider = true
        @requests = @service.service_requests
    end

    # return a list of relevant service providers for a specific service
    def available_service_providers
        @providers = ServiceProvider.order(rating: :desc).order(rating_count: :desc)
    end


    def my_requests
        render_forbidden "you're not a provider" and return unless @current_user.instance_of?(ServiceProvider)
         
        @with_client = true
        @with_service = true
        @requests = ServiceRequest.pending.where(service_provider_id: @current_user.id)
        render "services/requests"
    end


    def add_request
        # Validate data
        render_not_found 'service provider id not found' and return unless (provider_id = params[:service_provider_id])
        render_not_found "service provider with id '#{provider_id}' does not exist" and return unless (service_provider = ServiceProvider.find_by(id: provider_id))
        render_not_found 'service id not found' and return unless (service_id = params[:service_id])
        render_not_found "service with id '#{service_id}' does not exist" and return unless (service = Service.find_by(id: service_id))
        # Prevent duplicate requests
        render_forbidden "a service request had already been placed for service with id #{service_id} and service provider with id #{provider_id}" and return false unless ServiceRequest.find_by(service: service, service_provider: service_provider).nil?
        # Create new request
        request = ServiceRequest.new({:service_id => service_id, :service_provider_id => provider_id})
        # Handle save
        render_unprocessable_entity "couldn't save" and return false unless request.save
        # Render successful response
        @with_provider = true
        render 'services/_request', locals: {:request => request}

        # notify service provider
        NotificationsService.send_notification(@current_user, service_provider, NOTIFICATION_TYPE[:request_your_service], request.id)
    end

    def add_location
        # Retrieve service
        return unless get_service?

        render_not_found "location must have latitude" and return unless (latitude = params[:latitude])
        render_not_found "location must have longitude" and return unless (longitude = params[:longitude])

        location = Location.new({latitude: latitude, longitude: longitude, service_id: @service.id})

        if location.save
            render 'services/_location', locals: {:location => location}
        else
            render :json => {:error => "couldn't save"}, :status => 400
        end
    end

    def locations
        return unless get_service?
        @locations = @service.locations
    end

    # 3-way handshake - part #2
    def approve
        set_service_request_status(ServiceProvider, ServiceRequest.statuses[:approved])

        # notify client
        NotificationsService.send_notification(@current_user, @service_request.service.client, NOTIFICATION_TYPE[:approved_your_request], @service_request.service_id)
    end


    def deny
        set_service_request_status(ServiceProvider, ServiceRequest.statuses[:denied])
    end


    def cancel
        # Validate permissions
        return unless permitted_for_user_type?(Client)
        # Retrieve service
        return unless get_service?
        # Validate service status
        render_forbidden "a service in status #{@service.status} can't be canceled" and return unless (@service.confirmed? || @service.pending?)
        # Delete related service requests
        ServiceRequest.delete_all(service: @service)
        # Delete the service
        @service.delete
        # Render success
        render_success

        # notify service provider
        NotificationsService.send_notification(@current_user, @service.service_provider, NOTIFICATION_TYPE[:service_cancelled], @service.id)
    end

    # 3-way handshake - part #3
    def choose_service_provider
        #validate permissions
        return unless permitted_for_user_type?(Client)
        # Retrieve service request
        return unless get_service_request?
        render_not_found "service with id #{service.id} not found" and return unless (service = @service_request.service)
        # validate ownership on this service
        render_forbidden "you are not the client of this service request" and return unless service.client_id == @current_user.id
        # Validate service request is approved
        render_forbidden "service request with id #{@service_request.id} was not approved by service provider with id #{@service_request.service_provider.id}" and return unless (@service_request.approved?)

        # Set service provider
        service.service_provider = @service_request.service_provider
        # Confirm service
        service.confirmed!
        #handle save
        render_unprocessable_entity "couldn't save" and return false unless service.save
        # Delete all other related requests
        ServiceRequest.delete_all(service: service)
        # Render success
        render_success

        # notify service provider
        NotificationsService.send_notification(@current_user, service_provider, NOTIFICATION_TYPE[:confirmed_you_as_provider], service.id)
    end

    def start
        # Set status pre-requisites
        return unless service_pre_requisites_validated?(ServiceProvider)
        # Start service
        @service.time_start = Time.now.utc
        # Set status
        @service.status = Service.statuses[:started]
        # Handle save
        render_unprocessable_entity "couldn't save" and return false unless @service.save
        # Render success
        render_success

        # notify client
        NotificationsService.send_notification(@current_user, @service.client, NOTIFICATION_TYPE[:service_started], @service.id)
    end


    def end
        # Set status pre-requisites
        render_unauthorized and return unless service_pre_requisites_validated?(ServiceProvider)
        # End service
        @service.time_end = Time.now.utc
        # Set status
        @service.status = Service.statuses[:ended]
        # Handle save
        render_unprocessable_entity "couldn't save" and return false unless @service.save
        # Render success
        render_success

        # notify client
        NotificationsService.send_notification(@current_user, @service.client, NOTIFICATION_TYPE[:service_ended], @service.id)
    end


    private
    def service_pre_requisites_validated?(user_type)
        # Validate permissions
        return false unless permitted_for_user_type?(user_type)
        # Retrieve service request
        return false unless get_service?
        # Validate service provider is me
        return false unless service_provider_match?(@service.service_provider)
        true
    end


    private
    def set_service_request_status(user_type, new_status)
        # Validate permissions
        return false unless permitted_for_user_type?(user_type)
        # Retrieve service request
        return false unless get_service_request?
        # Validate service provider is me
        return false unless service_provider_match?(@service_request.service_provider)
        # Update status
        @service_request.status = new_status
        # Handle save
        render_unprocessable_entity "couldn't save" and return false unless @service_request.save
        # Render success
        render_success
    end


    private
    def get_service?
        # Retrieve service id from params
        render_not_found "service id not found" and return false unless (service_id = params[:service_id])
        # Retrieve request from DB
        render_not_found "service with id #{service_id} not found" and return false unless (@service = Service.find_by(id: service_id))
        true
    end


    private
    def get_service_request?
        # Retrieve service id from params
        render_not_found "service request id not found" and return false unless (request_id = params[:request_id])
        # Retrieve request from DB
        render_not_found "service with id #{request_id} not found" and return false unless (@service_request = ServiceRequest.find_by(id: request_id))
        true
    end


    private
    def parse_time(time)
        Time.at(time).to_datetime
    end


    private
    def permitted_for_user_type?(user_type)
        render_forbidden "you are not a #{user_type}" and return false unless @current_user.instance_of?(user_type)
        true
    end


    private
    def service_provider_match?(service_provider)
        render_forbidden "current service provider id #{@current_user.id} doesn't match request service provider id #{service_provider.id}" and return false unless (service_provider.id == @current_user.id)
        true
    end
end
