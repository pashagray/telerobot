RSpec.describe Telerobot::Utils do
  describe ".deep_symbolize_keys" do
    let(:input) do
      {
        "a": {
          "aa": {
            "aaa": "x",
            "aab": "x",
            aac: "x"
          },
          "ab": "x",
          ac: "x"
        },
        b: "x"
      }
    end

    let(:output) do
      {
        a: {
          aa: {
            aaa: "x",
            aab: "x",
            aac: "x"
          },
          ab: "x",
          ac: "x"
        },
        b: "x"
      }
    end

    it "transform all keys to symbols" do
      expect(described_class.deep_symbolize_keys(input)).to eq(output)
    end
  end
end
