class ServicesController < ApplicationController
    before_action :authenticate

    @@STATUS_PENDING = "pending"
    @@STATUS_DENIED = "denied"
    @@STATUS_APPROVED = "approved"

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
    def service_providers_for_service:

    end

    def add_request:
        render_error "service provider id not found" and return unless provider_id = params[:service_provider_id]
        render error "service provider with id '#{provider_id}' not exist" and return unless provider = ServiceProvider.find_by(id: provider_id)

        request = ServiceRequest.new({ :service_id => params[:service_id], :service_provider_id => provider_id })
    end

end
