# frozen_string_literal: true

RSpec.describe Telerobot::ReplyKeyboardMarkup do
  describe "#markup" do
    subject do
      described_class.new(
        [
          [
            "a",
            {
              text: "Phone please",
              request_contact: true
            },
            {
              text: "Location please",
              request_location: true
            }
          ],
          ["d", "f"]
        ],
        one_time: true
      )
    end

    it "returns keyboard markup in correct format" do
      expect(subject.markup).to eq(
        keyboard:
          [
            [
              {
                text: "a",
                request_contact: false,
                request_location: false
              },

              {
                text: "Phone please",
                request_contact: true,
                request_location: false
              },
              {
                text: "Location please",
                request_contact: false,
                request_location: true
              },
            ],
            [
              {
                text: "d",
                request_contact: false,
                request_location: false
              },
              {
                text: "f",
                request_contact: false,
                request_location: false
              }
            ]
          ],
        one_time_keyboard: true,
        resize_keyboard: false
      )
    end
  end
end
