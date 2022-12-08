require 'rspec'
require_relative '../../solutions/d7'

RSpec.describe Terminal do
  let(:terminal_log) do
    "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"
  end

  let(:terminal) { Terminal.new(terminal_log) }

  describe 'sum_small_directories' do
    subject { terminal.sum_small_directories }

    it { is_expected.to eq 95437 }
  end

  describe "smallest_possible_clear_size" do
    subject { terminal.smallest_possible_clear_size }

    it { is_expected.to eq 24933642 }
  end
end

RSpec.describe Directory do
  let(:directory) { Directory.new("/", nil) }
  let(:file) { StarFile.new("banana", 100) }

  describe "add_file" do
    subject { directory.add_file(file) }

    it "adds the file to it's list of contained files" do
      subject
      expect(directory.files).to include(file)
    end
  end

  describe "calc_file_size" do
    subject { directory.calc_file_size }
    context "when directory has no children" do
      before do
        directory.files << file
      end
      it "sums it's own files" do
        expect(directory.size).to eq 0
        subject
        expect(directory.size).to eq 100
      end
    end

    context "when directory has children" do
      let(:child_directory) { Directory.new("child", directory) }
      let(:grandchild_directory) { Directory.new("grandchild", child_directory) }

      before do
        directory.children << child_directory
        child_directory.children << grandchild_directory
        directory.files << file
        child_directory.files << StarFile.new("b", 500)
        grandchild_directory.files << StarFile.new("yyy", 500)
      end

      it "sums it's own files, and the total size of it's children" do
        expect(directory.size).to eq 0
        subject
        expect(directory.size).to eq 1100
      end
    end
  end

  describe "size_without_going_over" do
    subject { directory.size_without_going_over(1000) }

    context "when directory has children" do
      let(:child_directory) { Directory.new("child", directory) }
      let(:grandchild_directory) { Directory.new("grandchild", child_directory) }

      before do
        directory.children << child_directory
        child_directory.children << grandchild_directory
        directory.files << file
        child_directory.files << StarFile.new("b", 500)
        grandchild_directory.files << StarFile.new("yyy", 500)

        directory.calc_file_size
      end

      it "additively sums size of any directory who is smaller than the provided value, and all it's children" do
        expect(subject).to eq [0, 1000, 500]
      #  directory totals up to 1100 with all it's children, so is too big. Returns zero. child directory returns
      # it's own size, which includes child sizes. grandchild returns its own size.
      end
    end
  end

  describe "size_over_minimum" do
    subject { directory.size_over_minimum(500) }

    context "when directory has children" do
      let(:child_directory) { Directory.new("child", directory) }
      let(:grandchild_directory) { Directory.new("grandchild", child_directory) }

      before do
        directory.children << child_directory
        child_directory.children << grandchild_directory
        directory.files << file
        child_directory.files << StarFile.new("b", 500)
        grandchild_directory.files << StarFile.new("yyy", 400)

        directory.calc_file_size
      end

      it "additively sums size of any directory who is smaller than the provided value, and all it's children" do
        expect(subject).to eq [1000, 900, Float::INFINITY]
      #  directory totals up to 1100 with all it's children, so is too big. Returns zero. child directory returns
      # it's own size, which includes child sizes. grandchild returns its own size.
      end
    end
  end
end