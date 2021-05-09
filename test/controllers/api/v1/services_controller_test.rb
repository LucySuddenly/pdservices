require "test_helper"

class Api::V1::ServicesControllerTest < ActionDispatch::IntegrationTest
  test "#show" do
    status = get api_v1_service_path("Vost")
    assert status == 200
  end
  test "#show strips non-alphanumeric characters" do 
    status = get api_v1_service_path("(*&^Vost#&^%+_+_+,,,<><>)")
    assert status == 200
  end
  test "#show returns 404" do 
    status = get api_v1_service_path("Pay it no mind")
    assert status == 404
  end
end
