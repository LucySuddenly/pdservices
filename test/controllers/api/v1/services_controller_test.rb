require "test_helper"

class Api::V1::ServicesControllerTest < ActionDispatch::IntegrationTest
  test "#show" do
    status = get api_v1_service_path("Vost")
    assert status == 200
  end
  test "#show returns 404" do 
    status = get api_v1_service_path("Pay it no mind")
    assert status == 404
  end
  test "#show returns 503" do 
    PdClient::WebClient.stubs(:get).with("/services", {query: "query=literally anything", timeout: 2}).returns(HTTParty::ResponseError.new(503)).times(3)
    status = get api_v1_service_path("literally anything")
    assert status == 503
  end
end
