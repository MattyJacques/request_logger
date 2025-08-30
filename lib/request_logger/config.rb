# frozen_string_literal: true

module RequestLogger
  # Config class for RequestLogger
  # This class holds configuration options for logging HTTP requests and responses.
  #
  # @example
  #   RequestLogger.configure do |config|
  #     config.log_connection = true
  #     config.log_request = false
  #     config.log_response = false
  #     config.log_headers = true
  #   end
  class Config
    attr_accessor :log_connection, :log_request, :log_response, :log_headers

    def initialize
      @log_connection = false
      @log_request = true
      @log_response = true
      @log_headers = false
    end
  end
end
