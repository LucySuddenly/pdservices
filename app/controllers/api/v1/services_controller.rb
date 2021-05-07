class Api::V1::ServicesController < Api::V1::ApplicationController
    include PdClient
    def show 
        query = params[:id]
        service = nil
        renderOpts = {}
        begin
            service = get_first_matching_service(query)
            renderOpts[:status] = 200
        rescue StandardError => e 
            service = {error: "sorry, there was a problem: #{e}" }
            renderOpts[:status] = 503
        end
        render renderOpts.merge({json: service})
    end
end
