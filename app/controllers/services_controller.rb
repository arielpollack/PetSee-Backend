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

    def create

    end

    def requests
        service = Service.find_by(id: params[:service_id])
        if service.present?
            @requests = service.service_requests
        else
            render :json => {:error => 'service not found'}, :status => :not_found
        end

    end

    # return a list of relevant service providers for a specific service
    def service_providers_for_service

    end

    def add_request
        render_error "service provider id not found" and return unless provider_id = params[:service_provider_id]
        render_error "service provider with id '#{provider_id}' not exist" and return unless provider = ServiceProvider.find_by(id: provider_id)

        request = ServiceRequest.new({ :service_id => params[:service_id], :service_provider_id => provider_id })
    end

    def add_location
        render_error "service id not found" and return unless service_id = params[:service_id]
        render_error "service with id #{service_id} not found" and return unless service = Service.find_by(id: service_id)
        render_error "location must have latitude" and return unless latitude = params[:latitude]
        render_error "location must have longitude" and return unless longitude = params[:longitude]
        
        
        location = Location.new({ latitude: latitude, longitude: longitude, service_id: service_id })

        if location.save
            render :json => {}, :status => 200
        else
            render :json => { :error => "couldn't save" }, :status => 400
        end
    end

    def locations
        render_error "service id not found" and return unless service_id = params[:service_id]
        render_error "service with id #{service_id} not found" and return unless service = Service.find_by(id: service_id)

        @locations = service.locations
    end

end
