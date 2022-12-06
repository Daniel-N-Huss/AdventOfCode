require 'rspec'
require_relative '../../solutions/d6'

RSpec.describe SignalDecode do
  let(:signal_decode) { SignalDecode.new(test_input) }

  describe 'start_of_packet_position' do
    subject { signal_decode.start_of_packet_position }

    context "with a unique input" do
      let(:test_input) { "mjqjpqmgbljsphdztnvjfqwrcgsmlbv" }

      it { is_expected.to eq 7 }
    end

    context "with a unique input" do
      let(:test_input) { "bvwbjplbgvbhsrlpgdmjqwftvncz" }

      it { is_expected.to eq 5 }
    end

    context "with a unique input" do
      let(:test_input) { "nppdvjthqldpwncqszvftbrmjlhg" }

      it { is_expected.to eq 6 }
    end

    context "with a unique input" do
      let(:test_input) { "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" }

      it { is_expected.to eq 10 }
    end

    context "with a unique input" do
      let(:test_input) { "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" }

      it { is_expected.to eq 11 }
    end
  end

  describe 'start_of_message_position' do
    subject { signal_decode.start_of_message_position }

    context "with a unique input" do
      let(:test_input) { "mjqjpqmgbljsphdztnvjfqwrcgsmlbv" }

      it { is_expected.to eq 19 }
    end

    context "with a unique input" do
      let(:test_input) { "bvwbjplbgvbhsrlpgdmjqwftvncz" }

      it { is_expected.to eq 23 }
    end

    context "with a unique input" do
      let(:test_input) { "nppdvjthqldpwncqszvftbrmjlhg" }

      it { is_expected.to eq 23 }
    end

    context "with a unique input" do
      let(:test_input) { "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" }

      it { is_expected.to eq 29 }
    end

    context "with a unique input" do
      let(:test_input) { "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" }

      it { is_expected.to eq 26 }
    end
  end
end