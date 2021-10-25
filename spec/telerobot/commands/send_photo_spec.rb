# frozen_string_literal: true

RSpec.describe Telerobot::Commands::SendPhoto do
  describe "#photo_to_send" do
    context "with file id" do
      subject { described_class.new("AQADD7QxGxWvsUty") }

      it "returns id" do
        expect(subject.instance_variable_get(:@photo)).to eq("AQADD7QxGxWvsUty")
      end
    end

    context "with url" do
      subject { described_class.new("https://path.to.photo") }

      it "returns url" do
        expect(subject.instance_variable_get(:@photo)).to eq("https://path.to.photo")
      end
    end

    context "with path to local file" do
      context "when file exists" do
        subject { described_class.new("./spec/fixtures/robot.png") }

        it "returns file" do
          expect(subject.instance_variable_get(:@photo).inspect).to eq(File.open("./spec/fixtures/robot.png").inspect)
        end
      end
    end
  end
end
