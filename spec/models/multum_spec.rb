# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Multum, type: :model do
  let(:multum) { FactoryBot.build(:multum) }

  subject { multum }

  describe 'when respond to valor, status, etc' do
    it { should respond_to(:association) }
    it { should respond_to(:valor) }
    it { should respond_to(:status) }
    it { should respond_to(:data_pagamento) }
  end

  describe 'when valor is present' do
    it { should be_valid }
  end

  describe 'validations' do
    it { should validate_presence_of(:valor) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:emprestimo) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pendente: 0, pago: 1) }
  end
end
