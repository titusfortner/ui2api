require 'spec_helper'

RSpec.describe "#convert_to_model" do

  class TestConvertModel < WatirModel
    key(:foo) { Faker::Lorem.word }
    key(:bar) { Faker::Lorem.word }
  end

  class AltTestConvertModel < WatirModel
    key(:froo) { Faker::Lorem.word }
    key(:brar) { Faker::Lorem.word }
  end

  class TestConvert < WatirApi::Base
    def self.model_object
      TestConvertModel
    end
  end

  let(:test_convert_model) { TestConvertModel.new }
  let(:alt_test_convert_model) { AltTestConvertModel.new }
  let(:response) { double("Response") }
  before { allow(response).to receive(:code) }

  it 'converts hash into model' do
    allow(response).to receive(:body).and_return test_convert_model.to_api
    tc = TestConvert.new(response)
    expect(tc.data).to eq test_convert_model
  end

  it 'converts array into array of models' do
    array = Array.new(3) { TestConvertModel.new }
    allow(response).to receive(:body).and_return array.to_json

    tc = TestConvert.new(response)
    expect(tc.test_convert_models).to all(be_a TestConvertModel)
  end

  it 'ignores objects that are not Hashes or Arrays' do
    allow(response).to receive(:body).and_return Object

    expect(TestConvert.new(response).data).to eq nil
  end

  it 'does not convert mismatching Hash into a model' do
    allow(response).to receive(:body).and_return alt_test_convert_model.to_api
    tc = TestConvert.new(response)
    expect(tc.data).to eq alt_test_convert_model.to_hash
  end

  it 'does not convert mismatching array into array of models' do
    array = Array.new(3) { AltTestConvertModel.new }
    allow(response).to receive(:body).and_return array.to_json

    tc = TestConvert.new(response)
    expect(tc.data).to eq array.map(&:to_hash)
  end


end