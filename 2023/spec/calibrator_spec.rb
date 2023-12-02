require 'rspec'
require_relative '../solutions/d1'

RSpec.describe Calibrator do
  let(:sample_input) do
    <<~INPUT
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    INPUT
  end

  describe "#call" do
    let(:calibrator) { Calibrator.new(sample_input) }

    subject { calibrator.call }

    it "returns the sum of all calibration numbers in the input" do
      expect(subject).to eq(142)
    end

    context "with input subset" do
      let(:sample_input) do
        <<~INPUT
          eightqrssm9httwogqshfxninepnfrppfzhsc
          one111jxlmc7tvklrmhdpsix
          bptwone4sixzzppg
          ninezfzseveneight5kjrjvtfjqt5nineone
          58kk
          5b32
          1dtwo
          six7two7sixtwo78
        INPUT
      end

      it "returns the sum of all calibration numbers in the input" do
        expect(subject).to eq([99, 17, 44, 55, 58, 52, 11, 78].sum)
      end
    end

    context "with input file" do
      let(:sample_input) { File.read("inputs/d1.txt") }

      it "returns the sum of all calibration numbers in the input" do
        expect(subject).to eq(54159)
      end
    end

    context "when parsing text-based numbers" do
      let(:calibrator) { Calibrator.new(sample_input, use_text_numbers: true) }
      let(:sample_input) do
        <<~INPUT
          two1nine
          eightwothree
          abcone2threexyz
          xtwone3four
          4nineeightseven2
          zoneight234
          7pqrstsixteen
        INPUT
      end

      it "returns the sum of all calibration numbers in the input" do
        expect(subject).to eq(281)
      end

      context "with a subset of the input file" do
        let(:sample_input) do
          <<~INPUT
            eightqrssm9httwogqshfxninepnfrppfzhsc
            one111jxlmc7tvklrmhdpsix
            bptwone4sixzzppg
            ninezfzseveneight5kjrjvtfjqt5nineone
            58kk
            5b32
            1dtwo
            six7two7sixtwo78
          INPUT
        end

        it "returns the sum of all calibration numbers in the input" do
          expect(subject).to eq([89, 16, 26, 91, 58, 52, 12, 68].sum)
        end
      end

      context "with the input file" do
        let(:sample_input) { File.read("inputs/d1.txt") }

        it "returns the sum of all calibration numbers in the input" do
          expect(subject).to eq(53866)
        end
      end
    end
  end
end
