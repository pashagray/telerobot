# frozen_string_literal: true

RSpec.describe Telerobot::ReplyKeyboardMarkup do
  describe "#markup" do
    subject { described_class.new([["a", "b", "c"], ["d", "f"]], one_time: true) }

    it "returns keyboard markup in correct format" do
      expect(subject.markup).to eq(
        keyboard: [["a", "b", "c"], ["d", "f"]],
        one_time_keyboard: true,
        resize_keyboard: false
      )
    end
  end
end
