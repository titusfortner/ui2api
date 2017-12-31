require 'spec_helper'

module WatirApi
  RSpec.describe "Addresses" do

    let(:address) { Model::Address.new }

    before { API::User.create }

    describe "#create" do
      it "adds new address" do
        API::Address.create(address)

        addresses = API::Address.index.addresses

        expect(addresses).to include(address)
      end
    end

    describe "#index" do
      it "returns addresses as Array of Address Models" do
        6.times { API::Address.create }

        addresses = API::Address.index.addresses

        expect(addresses).to all(be_a Model::Address)
        expect(addresses.size).to eq 6
      end
    end

    describe "#show" do
      it "returns address information as a WatirModel" do
        id = API::Address.create(address).id

        show_address = API::Address.show(id: id)

        expect(show_address.address).to eq address
      end
    end

    describe "#update" do
      it "changes address details" do
        id = API::Address.create(address).id

        updated_address = Model::Address.new
        API::Address.update(id: id, with: updated_address)

        show_address = API::Address.show(id: id).address
        expect(show_address).to eq updated_address
      end
    end

    describe "#destroy" do
      it "deletes booking" do
        3.times { API::Address.create }
        id = API::Address.create.id

        API::Address.destroy(id: id)

        show_address = API::Address.show(id: id).address

        expect(show_address).to eq nil

        addresses = API::Address.index.addresses
        expect(addresses.size).to eq 3
      end
    end
  end
end
