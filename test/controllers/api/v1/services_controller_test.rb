require "test_helper"

class Api::V1::ServicesControllerTest < ActionDispatch::IntegrationTest
  test "#show" do
    status = get api_v1_service_path("Vost")
    assert status == 200
  end
end
