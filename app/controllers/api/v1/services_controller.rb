class Api::V1::ServicesController < Api::V1::ApplicationController
    include PdClient
    def show 
        query = params[:id]
        service = nil
        renderOpts = {}

        begin
            service = get_first_matching_service(query)
            renderOpts[:status] = 200
            if service.nil?
                service = {error: "no services in this organization matched your query"} 
                renderOpts[:status] = 404
            end
        rescue StandardError => e 
            service = {error: "sadface, bogus things happened somewhere in our machinery" }
            renderOpts[:status] = 503
        end
        render renderOpts.merge({json: service})
    end
end
