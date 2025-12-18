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
  #     config.url_list_type = :whitelist
  #     config.url_list = ['example.com']
  #   end
  class Config
    attr_accessor :log_connection,
                  :log_request,
                  :log_response,
                  :log_headers,
                  :url_list

    attr_reader :url_list_type

    def initialize
      @log_connection = false
      @log_request = true
      @log_response = true
      @log_headers = false
      @url_list_type = :blacklist
      @url_list = []
    end

    def url_list_type=(value)
      unless %i[none whitelist blacklist].include?(value)
        raise ArgumentError, 'url_list_type must be :none, :whitelist, or :blacklist'
      end

      @url_list_type = value
    end
  end
end
