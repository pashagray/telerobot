# frozen_string_literal: true

RSpec.describe Telerobot::InlineKeyboardMarkup do
  describe "#markup" do
    subject do
      described_class.new(
        [
          [
            "a",
            {
              text: "Load more",
              callback_data: "load_more"
            },
            {
              text: "Buy me a coffee",
              pay: true
            }
          ],
          ["d", "f"]
        ]
      )
    end

    it "returns keyboard markup in correct format" do
      expect(subject.markup).to eq(
        keyboard:
          [
            [
              {
                text: "a"
              },

              {
                text: "Load more",
                callback_data: "load_more"
              },

              {
                text: "Buy me a coffee",
                pay: true
              },
            ],
            [
              {
                text: "d"
              },
              {
                text: "f"
              }
            ]
          ]
      )
    end
  end
end
