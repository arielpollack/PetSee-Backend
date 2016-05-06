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

end
