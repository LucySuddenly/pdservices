require 'test_helper'

class PdClientTest < ActiveSupport::TestCase
    lucyObj = { name: "Lucy" }
    payload = { services: [{ name: "zLexicographically larger than Lucy"}, lucyObj] } 
    req = HTTParty::Request.new("GET", "services", {})
    res = StubResponse.new(payload)
    parsed = lambda { payload }
    stub = HTTParty::Response.new(req, res, parsed)

    test "#get_with_retries" do 
        WebClient.stubs(:get).with("/services", {timeout: 2}).returns(stub).once
    
        resp = get_with_retries("/services")

        # assert pass-thru
        assert resp[:services][1][:name] == lucyObj[:name]
    end

    test "#get_with_retries retries on error" do 
        WebClient.stubs(:get).with("/services", {timeout: 2}).raises(HTTParty::ResponseError.new(503)).times(3)
        begin
            resp = get_with_retries("/services")
        rescue StandardError => e
            assert e.message.to_i == 503 
            assert_nil(resp)
        end
    end

    test "#get_first_matching_service" do 
        WebClient.stubs(:get).with("/services", {:query => "query=Lucy", timeout: 2}).returns(stub).once

        service = get_first_matching_service("Lucy")
        # assert pass-thru and sort
        assert service[:name] == lucyObj[:name]
    end
end