# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bibliotecario, type: :model do
  let(:bibliotecario) { FactoryBot.build(:bibliotecario) }

  subject { bibliotecario }

  it { should respond_to(:email) }
  it { should respond_to(:password) }

  it { should be_valid }
end
