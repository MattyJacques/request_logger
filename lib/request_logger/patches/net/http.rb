# frozen_string_literal: true

require 'net/http'

module Net
  # This class hooks into Net::HTTP connect and request methods
  class HTTP
    alias original_connect connect
    alias original_request request

    def connect
      # Hook before connect

      original_connect

      # Hook after connect
      RequestLogger.log_connection(address, port)
    end

    def request(req, body = nil, &)
      # Hook before request

      response = original_request(req, body, &)

      # Hook after request
      return response unless loggable?(address)

      log_request(req, body, response)

      response
    end

    private

    def loggable?(address)
      config = RequestLogger.config
      return true if config.url_list.nil? || config.url_list.empty?

      case config.url_list_type
      when :whitelist
        config.url_list.include?(address)
      when :blacklist
        !config.url_list.include?(address)
      else
        true
      end
    end

    def log_request(req, body, response)
      RequestLogger.log(
        request: {
          method: req.method,
          path: "http://#{address}:#{port}#{req.path}",
          headers: req.each_header.to_h,
          body: body
        },
        response: { headers: response.each_header.to_h, code: response.code, body: response.body }
      )
    end
  end
end
