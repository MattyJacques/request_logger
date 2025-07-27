# frozen_string_literal: true

require 'json'

RSpec.describe RequestLogger do
  let(:path) { 'http://example.com/api/resource' }
  let(:port) { 80 }

  it 'has a version number' do
    expect(RequestLogger::VERSION).not_to be_nil
  end

  describe '.log_connection' do
    before do
      described_class.configure do |config|
        config.log_connection = true
      end
    end

    it 'logs connection details' do
      expect { described_class.log_connection(path, port) }
        .to output("[Request] Connected to #{path}:#{port}\n").to_stdout
    end
  end

  describe '.log' do
    let(:params) do
      {
        request:
        {
          method: 'GET',
          path:,
          headers: { 'Content-Type' => 'application/json' },
          body: '{"data":"gimme it all"}'
        },
        response:
        {
          code: 200,
          headers: { 'Content-Length' => '123' },
          body: '{"data":"all of it"}'
        }
      }
    end
    let(:expected_output) do
      {
        path: "[Request] Path: GET #{path}",
        headers: "[Request] Headers: #{params[:request][:headers]}",
        body: "[Request] Body: #{params[:request][:body].to_json}",
        status: "[Request] Status: #{params[:response][:code]}",
        response_headers: "[Request] Headers: #{params[:response][:headers]}",
        response_body: "[Request] Body: #{params[:response][:body].to_json}"
      }
    end

    it 'logs request and response details' do
      expect do
        described_class.log(params)
      end.to output(
        [
          expected_output[:path],
          expected_output[:body],
          expected_output[:status],
          expected_output[:response_body]
        ].join("\n").concat("\n")
      ).to_stdout
    end

    context 'when logging is configured' do
      context 'when configs are all true' do
        before do
          described_class.configure do |config|
            config.log_request = true
            config.log_response = true
            config.log_headers = true
          end
        end

        it 'logs everything' do
          expect do
            described_class.log(params)
          end.to output(
            [
              expected_output[:path],
              expected_output[:headers],
              expected_output[:body],
              expected_output[:status],
              expected_output[:response_headers],
              expected_output[:response_body]
            ].join("\n").concat("\n")
          ).to_stdout
        end
      end

      context 'when configs are all false' do
        before do
          described_class.configure do |config|
            config.log_connection = false
            config.log_request = false
            config.log_response = false
            config.log_headers = false
          end
        end

        it 'does not log anything' do
          expect { described_class.log(params) }.not_to output.to_stdout
        end
      end
    end
  end
end
