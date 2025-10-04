# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bibliotecario, type: :model do
  let(:bibliotecario) { FactoryBot.build(:bibliotecario) }

  subject { bibliotecario }

  describe 'when respond to email, password' do
    it { should respond_to(:email) }
    it { should respond_to(:password) }
  end

  describe 'when email is present' do
    it { should be_valid }
  end

  describe 'when email is not present' do
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_confirmation_of(:password) }
    it { should validate_presence_of(:email) }
    it { should allow_value('email@domain.com').for(:email) }
  end

end
