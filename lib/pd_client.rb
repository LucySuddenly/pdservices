require 'httparty'

module PdClient
    include HTTParty

    private

    mattr_accessor :api_key
    self.api_key ||= Rails.configuration.pd_token

    # production apps need configureable per-env resources
    base_uri 'https://api.pagerduty.com/'.freeze
    headers 'Authorization': "Token token=#{self.api_key}"

    public


    def get_first_matching_service(query = "")
        raise ArgumentError, 'query cannot be empty' if query == ""

        resp = self.get_with_retries 'services', { query: query }

        resp[:services].sort_by {|s| s[:name] }.first
    end

    def get_with_retries(path, options={})
        raise ArgumentError, 'path cannot be empty' if path == ""
        attempts = 0
        begin
            attempts += 1
            # add more rubust resp code handling and configurable timeout duration
            self.class.get(path, options.merge(timeout: 2)).parsed_response
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