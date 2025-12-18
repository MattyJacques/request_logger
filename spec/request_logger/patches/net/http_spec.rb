# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Net::HTTP do
  let(:http) { described_class.new('example.com', 80) }
  let(:request) { Net::HTTP::Get.new('/api/test') }
  let(:response) { Net::HTTPResponse.new('1.1', '200', 'OK') }

  before do
    allow(http).to receive(:original_connect)
    allow(RequestLogger).to receive(:log)
  end

  describe '#connect' do
    it 'calls the original connect method' do
      expect(http).to receive(:original_connect)

      http.start
    end

    it 'logs connection details' do
      expect(RequestLogger).to receive(:log_connection).with('example.com', 80)

      http.start
    end
  end

  describe '#request' do
    let(:expected_payload) do
      {
        request:
        {
          method: 'GET',
          path: "http://#{http.address}:#{http.port}#{request.path}",
          headers: request.each_header.to_h,
          body: request_body
        },
        response: { headers: response.each_header.to_h, code: '200', body: response_body }
      }
    end
    let(:request_body) { nil }
    let(:response_body) { nil }

    before do
      allow(http).to receive(:original_request).with(request, request_body).and_return(response)
      allow(response).to receive(:body).and_return(response_body)
    end

    it 'calls the original request method' do
      expect(http).to receive(:original_request).with(request, nil)

      http.request(request)
    end

    it 'logs request and response details' do
      expect(RequestLogger).to receive(:log).with(expected_payload)

      http.request(request)
    end

    context 'with url_list_type = :whitelist' do
      before do
        RequestLogger.config.url_list_type = :whitelist
        RequestLogger.config.url_list = ['example.com']
      end

      context 'when host is in the list' do
        it 'logs the request' do
          expect(RequestLogger).to receive(:log).with(expected_payload)
          http.request(request)
        end
      end

      context 'when host is not in the list' do
        let(:http) { described_class.new('another-example.com', 80) }

        it 'does not log the request' do
          expect(RequestLogger).not_to receive(:log)
          http.request(request)
        end
      end

      context 'when list is empty' do
        before do
          RequestLogger.config.url_list = []
        end

        it 'logs the request' do
          expect(RequestLogger).to receive(:log).with(expected_payload)
          http.request(request)
        end
      end
    end

    context 'with url_list_type = :blacklist' do
      before do
        RequestLogger.config.url_list_type = :blacklist
        RequestLogger.config.url_list = ['another-example.com']
      end

      context 'when host is not in the list' do
        it 'logs the request' do
          expect(RequestLogger).to receive(:log).with(expected_payload)
          http.request(request)
        end
      end

      context 'when host is in the list' do
        let(:http) { described_class.new('another-example.com', 80) }

        it 'does not log the request' do
          expect(RequestLogger).not_to receive(:log)
          http.request(request)
        end
      end

      context 'when list is empty' do
        before do
          RequestLogger.config.url_list = []
        end

        it 'logs the request' do
          expect(RequestLogger).to receive(:log).with(expected_payload)
          http.request(request)
        end
      end
    end

    context 'with request body' do
      let(:request_body) { '{"key":"value"}' }
      let(:response_body) { '{"status":"success"}' }

      it 'logs request body' do
        expect(RequestLogger).to receive(:log).with(expected_payload)

        http.request(request, request_body)
      end
    end
  end
end
