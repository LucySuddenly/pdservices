ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require_relative "../lib/pd_client"
require "rails/test_help"
require 'mocha/minitest'


class ActiveSupport::TestCase
  include PdClient
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  class StubResponse
    attr_accessor :body
    def initialize(body={})
      @body=body
    end
    
    def to_hash
      @body
    end
  end

  # Add more helper methods to be used by all tests here...
end
