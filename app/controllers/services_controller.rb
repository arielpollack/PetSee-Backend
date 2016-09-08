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
      @with_service_provider = false
    end
  end


  # Create new service by client (3-way handshake - part #1)
  def create
    unless @current_user.instance_of?(Client)
      render :json => {:error => 'you are not a client'}, :status => :forbidden
      return
    end

    pet = Pet.find_by_id(params[:pet_id])
    render_error "pet does not exist" and return if pet.nil?
    render_error "this is not your pet" and return if pet.owner.id != @current_user.id
    render_error "location is missing" and return unless params[:lat].present? and params[:lng].present?

    new_service = {}
    new_service[:client_id] = @current_user.id
    new_service[:pet_id] = params[:pet_id]
    new_service[:type] = params[:type]
    new_service[:time_start] = Time.at(params[:time_start].to_i).to_datetime
    new_service[:time_end] = Time.at(params[:time_end].to_i).to_datetime

    # generate location for service
    location = Location.new({:latitude => params[:lat], :longitude => params[:lng]})
    render_error "couldn't save location" and return unless location.save
    new_service[:location_id] = location.id

    @with_client = true
    @with_service_provider = false

    service = Service.new(new_service)
    if service.save
      render 'services/_service', :locals => {:service => service}
    else
      render :json => {:has_errors => true, :errors => service.errors}, :status => :unprocessable_entity
    end
  end

  def requests
    service = Service.find_by(id: params[:service_id])
    if service.present?
        @with_provider = true
        @requests = service.service_requests
    else
      render :json => {:error => 'service not found'}, :status => :not_found
    end

  end

    def my_requests
        render_error "you're not a provider" and return unless @current_user.instance_of?(ServiceProvider)

        @with_client = true
        @with_service = true
        @requests = @current_user.service_requests
        render "services/requests"
    end

    # return a list of relevant service providers for a specific service
    def available_service_providers
        last_index = params[:last_index] || 0
        Rails.logger.info "Last index is: #{last_index}"

        @providers = ServiceProvider.all.order(rating: :asc).order(rating_count: :asc).where("id > ?", last_index).limit(20)
    end

  def add_request
    render_error "service provider id not found" and return unless (provider_id = params[:service_provider_id])
    render_error "service provider with id '#{provider_id}' not exist" and return unless (provider = ServiceProvider.find_by(id: provider_id))

    request = ServiceRequest.new({:service_id => params[:service_id], :service_provider_id => provider_id})
    if request.save
      render 'services/_request', locals: {:request => request}
    else
      render_error "couldn't save"
    end
  end

  def add_location
    render_error "service id not found" and return unless (service_id = params[:service_id])
    render_error "service with id #{service_id} not found" and return unless (service = Service.find_by(id: service_id))
    render_error "location must have latitude" and return unless (latitude = params[:latitude])
    render_error "location must have longitude" and return unless (longitude = params[:longitude])

    location = Location.new({latitude: latitude, longitude: longitude, service_id: service_id})

    if location.save
      render 'services/_location', locals: {:location => location}
    else
      render :json => {:error => "couldn't save"}, :status => 400
    end
  end

  def locations
    render_error "service id not found" and return unless (service_id = params[:service_id])
    render_error "service with id #{service_id} not found" and return unless (service = Service.find_by(id: service_id))

    @locations = service.locations
  end

  # 3-way handshake - part #2
  def approve
    #validate permissions
    unless @current_user.instance_of?(ServiceProvider)
      render :json => {:error => 'you are not a service provider'}, :status => :forbidden
      return
    end
    #handle action
    service_response(ServiceRequest.statuses[:approved])
  end

  def deny
    #validate permissions
    unless @current_user.instance_of?(ServiceProvider)
      render :json => {:error => 'you are not a service provider'}, :status => :forbidden
      return
    end
    #handle action
    service_response(ServiceRequest.statuses[:denied])
  end

  def cancel
    # Validate permissions
    unless @current_user.instance_of?(Client)
      render :json => {:error => 'you are not a client'}, :status => :forbidden
      return
    end
    # Retrieve service id from params
    render_error "service id not found" and return unless (service_id = params[:service_id])
    # Retrieve request from DB
    render_error "service with id #{service_id} not found" and return unless (service = Service.find_by(id: service_id))
    # Validate service status
    render_error "a service in status #{service.status} can't be canceled" and return unless (service.confirmed? || service.pending?)
    # Delete related service requests
    ServiceRequest.delete_all(service: service)
    # Delete the service
    service.delete
    # Render success
    render :json => {}, :status => 200
  end

  # 3-way handshake - part #3
  def choose_service_provider
    #validate permissions
    unless @current_user.instance_of?(Client)
      render :json => {:error => 'you are not a client'}, :status => :forbidden
      return
    end
    # Retrieve request_id from params
    render_error "service request id not found" and return unless (request_id = params[:request_id])
    # Retrieve request from DB
    render_error "service request with id #{request_id} not found" and return unless (request = ServiceRequest.find_by(id: request_id))
    # Validate service request is approved
    render_error "service request with id #{request_id} was not approved by service provider with id #{request.service_provider.id}" and return unless (request.approved?)
    # Retrieve service from DB
    render_error "service with id #{request.service.id} not found" and return unless (service = request.service)
    # Confirm service
    service.status = Service.statuses[:confirmed]
    #handle save
    if service.save
      render :json => {}, :status => 200
    else
      render_error "couldn't save"
    end
    # Delete all other related requests
    ServiceRequest.delete_all(service: service)
  end

  private
  def service_response(response)
    #retrieve request_id from params
    render_error "service request id not found" and return unless (request_id = params[:request_id])
    #retrieve request from DB
    render_error "service request with id #{request_id} not found" and return unless (request = ServiceRequest.find_by(id: request_id))
    #validate service_provider
    service_provider = request.service_provider
    render_error "current service provider id #{@current_user.id} doesn't match request service provider id #{service_provider.id}" and return unless (service_provider.id == @current_user.id)
    #update status
    request.status = response
    #handle save
    if request.save
      render :json => {}, :status => 200
    else
      render_error "couldn't save"
    end
  end
end
