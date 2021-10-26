# frozen_string_literal: true
require "./spec/fixtures/types"

RSpec.describe "Typing system" do
  describe "with plain hash" do
    let(:hash) do
      {
        id: 170,
        text: "Let's go!",
        date: Time.new(1961, 4, 12).to_i,
        from: {
          id: 1,
          last_name: "Gagarin",
          first_name: "Yuri",
          country: {
            title: "USSR",
            code: "SU"
          }
        }
      }
    end

    it "returns correct typed structure" do
      type = Telerobot::Types::Report.new(hash)
      expect(type.id).to eq(170)
      expect(type.text).to eq("Let's go!")
      expect(type.date).to eq(Time.new(1961, 4, 12).to_i)
      expect(type.from).to be_a(Telerobot::Types::User)
      expect(type.from.id).to eq(1)
      expect(type.from.last_name).to eq("Gagarin")
      expect(type.from.first_name).to eq("Yuri")
      expect(type.from.country).to be_a(Telerobot::Types::Country)
      expect(type.from.country.title).to eq("USSR")
      expect(type.from.country.code).to eq("SU")
    end
  end

  describe "with types in hash" do
    let(:hash) do
      {
        id: 170,
        text: "Let's go!",
        date: Time.new(1961, 4, 12).to_i,
        from: Telerobot::Types::User.new(
          id: 1,
          last_name: "Gagarin",
          first_name: "Yuri",
          awards: [
            { title: "Hero of the Soviet Union" },
            { title: "Order of Lenin" }
          ],
          country: Telerobot::Types::Country.new(
            title: "USSR",
            code: "SU"
          )
        )
      }
    end

    it "returns correct typed structure" do
      type = Telerobot::Types::Report.new(hash)
      expect(type.id).to eq(170)
      expect(type.text).to eq("Let's go!")
      expect(type.date).to eq(Time.new(1961, 4, 12).to_i)
      expect(type.from).to be_a(Telerobot::Types::User)
      expect(type.from.id).to eq(1)
      expect(type.from.last_name).to eq("Gagarin")
      expect(type.from.first_name).to eq("Yuri")
      expect(type.from.country).to be_a(Telerobot::Types::Country)
      expect(type.from.country.title).to eq("USSR")
      expect(type.from.country.code).to eq("SU")
      expect(type.from.awards[0]).to be_a(Telerobot::Types::Award)
      expect(type.from.awards[0].title).to eq("Hero of the Soviet Union")
      expect(type.from.awards[1]).to be_a(Telerobot::Types::Award)
      expect(type.from.awards[1].title).to eq("Order of Lenin")
    end
  end
end
