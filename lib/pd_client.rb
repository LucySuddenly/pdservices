require 'httparty'

module PdClient
    class WebClient
        include HTTParty

        private

        mattr_accessor :api_key
        @@PD_TOKEN = Rails.configuration.pd_token

        # production apps need configureable per-env resources
        self.base_uri 'https://api.pagerduty.com'
        self.headers 'Authorization': "Token token=#{@@PD_TOKEN}"
        self.format :json
    end

    def get_first_matching_service(query = "")
        raise ArgumentError, 'query cannot be empty' if query == ""

        resp = self.get_with_retries '/services', { query: "query=" + query }
        resp = resp.with_indifferent_access
        resp[:services].sort_by {|s| s[:name] }.first
    end

    def get_with_retries(path, options={})
        raise ArgumentError, 'path cannot be empty' if path == ""
        attempts = 0
        begin
            attempts += 1
            # add more rubust resp code handling and configurable timeout duration

            WebClient.get(path, options.merge(timeout: 2)).parsed_response
        rescue HTTParty::Error, StandardError => e
            # make configurable
            if attempts < 3 
                # log or expo backoff would be better
                sleep 0.5
                retry 
            else 
                raise StandardError.new e
            end
        end
    end

end