# frozen_string_literal: true

require_relative 'request_logger/version'
require_relative 'request_logger/patches/net/http'

# RequestLogger is a simple HTTP request/response logger for Ruby applications.
module RequestLogger
  class Error < StandardError; end

  class << self
    def log_connection(host, port)
      send_log("Connected to #{host}:#{port}")
    end

    def log(params)
      log_request(params[:request])
      log_response(params[:response])
    end

    private

    def log_request(request)
      log_path(request[:method], request[:path])
      log_headers(request[:headers])
      log_body(request[:body])
    end

    def log_response(response)
      log_status_code(response[:code])
      log_headers(response[:headers])
      log_body(response[:body])
    end

    def log_path(method, path)
      send_log("Path: #{method} #{path}")
    end

    def log_headers(headers)
      send_log("Headers: #{headers.inspect}")
    end

    def log_body(body)
      return unless body

      send_log("Body: #{body.inspect}")
    end

    def log_status_code(status)
      send_log("Status: #{status}")
    end

    def send_log(message)
      puts("[Request] #{message}")
    end
  end
end
