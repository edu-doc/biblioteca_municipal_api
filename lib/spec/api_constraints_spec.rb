# frozen_string_literal: true


require 'rails_helper'


describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }

  describe '#matches?' do
    it "returns the default version when 'default' option is specified" do
      request = double(host: '127.0.0.1')

      expect(api_constraints_v1.matches?(request)).to be_truthy
    end
  end
end
