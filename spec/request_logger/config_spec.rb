# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RequestLogger::Config do
  subject(:config) { described_class.new }

  describe '#url_list_type=' do
    context 'with valid values' do
      it 'accepts :none' do
        expect { config.url_list_type = :none }.not_to raise_error
        expect(config.url_list_type).to eq(:none)
      end

      it 'accepts :whitelist' do
        expect { config.url_list_type = :whitelist }.not_to raise_error
        expect(config.url_list_type).to eq(:whitelist)
      end

      it 'accepts :blacklist' do
        expect { config.url_list_type = :blacklist }.not_to raise_error
        expect(config.url_list_type).to eq(:blacklist)
      end
    end

    context 'with an invalid value' do
      it 'raises an ArgumentError' do
        expect { config.url_list_type = :invalid_type }
          .to raise_error(ArgumentError, 'url_list_type must be :none, :whitelist, or :blacklist')
      end
    end
  end
end
