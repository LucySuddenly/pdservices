class Api::V1::ServicesController < Api::V1::ApplicationController
    include PdClient

    def show 
        query = params[:id]
        # call api client
    end
end
