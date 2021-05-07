require 'test_helper'

class PdClientTest < ActiveSupport::TestCase
    lucyObj = { name: "Lucy" }
    payload = { services: [{ name: "zLexicographically larger than Lucy"}, lucyObj] } 
    req = HTTParty::Request.new("GET", "services", {})
    res = StubResponse.new(payload)
    parsed = lambda { payload }
    stub = HTTParty::Response.new(req, res, parsed)

    test "#get_with_retries" do 
        WebClient.stubs(:get).with("services", {timeout: 2}).returns(stub)
    
        resp = get_with_retries("services")

        # assert pass-thru
        assert resp[:services][1][:name] == lucyObj[:name]
    end

    test "#get_with_retries retries on error" do 
        WebClient.stubs(:get).with("services", {timeout: 2}).returns(StandardError).times(3)
        begin
        list = get_with_retries("services")
        rescue StandardError
            assert_nil(list)
        end
    end

    test "#get_first_matching_service" do 
        WebClient.stubs(:get).with("/services", {:query => "query=Lucy", timeout: 2}).returns(stub)

        service = get_first_matching_service("Lucy")
        # assert pass-thru and sort
        assert service[:name] == lucyObj[:name]
    end
end