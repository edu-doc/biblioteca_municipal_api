require 'rails_helper'

RSpec.describe Categoria, type: :model do
  let(:categoria) { FactoryBot.build :categoria }
  subject { categoria }

  describe 'when respond to nome' do
    it { should respond_to(:nome) }
  end

  describe 'when nome is present' do
    it { should be_valid }
  end

  describe 'when nome is not present' do
    it { should validate_uniqueness_of(:nome) }
    it { should validate_presence_of(:nome) }
  end

end
