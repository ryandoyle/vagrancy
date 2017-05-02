require 'spec_helper'
require 'vagrancy/helpers/param_sanitizer'

describe Vagrancy::Helpers::ParamSanitizer do

  let(:sanitizer) { Class.new.extend(described_class)}

  describe '#sanitised_param' do
    describe 'invalid params' do
      it 'raises an error for /' do
        allow(sanitizer).to receive(:params).and_return({:user => '/' })
        
        expect{sanitizer.sanitised_param :user }.to raise_error Vagrancy::Helpers::InvalidParameterName
      end
      it 'raises an error for ..' do
        allow(sanitizer).to receive(:params).and_return({:user => '..' })

        expect{sanitizer.sanitised_param :user }.to raise_error Vagrancy::Helpers::InvalidParameterName
      end
      it 'raises an error for %' do
        allow(sanitizer).to receive(:params).and_return({:user => '%' })

        expect{sanitizer.sanitised_param :user }.to raise_error Vagrancy::Helpers::InvalidParameterName
      end
    end

    describe 'valid params' do
      it 'returns the param' do
        allow(sanitizer).to receive(:params).and_return({:user => 'my-user' })

        expect(sanitizer.sanitised_param :user).to eq 'my-user'
      end
    end
  end
end