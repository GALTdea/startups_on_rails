ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Only load fixtures we need for this test
    fixtures :users

    # Add more helper methods to be used by all tests here...
  end
end
