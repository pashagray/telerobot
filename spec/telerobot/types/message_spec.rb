# frozen_string_literal: true

RSpec.describe Telerobot::Types::Message do
  describe "#initialize" do
    let(:arguments) do
      {
        message_id: 1,
        text: "Hello, world!",
        date: Time.now.to_i,
        photo: [
          { file_id: "file_id", file_unique_id: "file_unique_id_1", file_size: 1, width: 1, height: 1 },
          { file_id: "file_id", file_unique_id: "file_unique_id_2", file_size: 2, width: 2, height: 2 }
        ]
      }
    end

    it "has proper class for message_id" do
      expect(described_class.new(arguments).message_id).to be_a(Integer)
    end

    it "has proper class for text" do
      expect(described_class.new(arguments).text).to be_a(String)
    end

    it "has proper class for date" do
      expect(described_class.new(arguments).date).to be_a(Integer)
    end

    it "has proper class for photo" do
      puts described_class.new(arguments).photo.inspect
      expect(described_class.new(arguments).photo).to be_a(Array)
      expect(described_class.new(arguments).photo.first).to be_a(Telerobot::Types::PhotoSize)
    end
  end
end
