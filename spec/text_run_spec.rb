# coding: utf-8

require File.dirname(__FILE__) + "/spec_helper"

describe PDF::Reader::TextRun, "#initilize" do
  context "when initialized with valid values" do
    let(:x)     { 10 }
    let(:y)     { 20 }
    let(:width) { 30 }
    let(:text)  { "Chunky" }

    subject { PDF::Reader::TextRun.new(x, y, width, text)}

    it "should make x accessible" do
      subject.x.should == 10
    end

    it "should make y accessible" do
      subject.y.should == 20
    end

    it "should make width accessible" do
      subject.width.should == 30
    end

    it "should make text accessible" do
      subject.text.should == "Chunky"
    end
  end
end

describe PDF::Reader::TextRun, "#endx" do
  context "when initialized with valid values" do
    let(:x)     { 10 }
    let(:y)     { 20 }
    let(:width) { 30 }
    let(:text)  { "Chunky" }

    subject { PDF::Reader::TextRun.new(x, y, width, text)}

    it "should equal x + width" do
      subject.endx.should == 40
    end
  end
end

describe PDF::Reader::TextRun, "#mergable?" do
  let(:x)     { 10 }
  let(:y)     { 20 }
  let(:width) { 30 }

  context "when the two runs are within 10pts of each other" do
    let(:one)   { PDF::Reader::TextRun.new(x,          y, width, "A")}
    let(:two)   { PDF::Reader::TextRun.new(one.endx+9, y, width, "B")}

    it "should return true" do
      one.mergable?(two).should be_true
    end
  end

  context "when the two runs are over 10pts away from each other" do
    let(:one)   { PDF::Reader::TextRun.new(x,           y, width, "A")}
    let(:two)   { PDF::Reader::TextRun.new(one.endx+11, y, width, "B")}

    it "should return false" do
      one.mergable?(two).should be_false
    end
  end

  context "when the two runs have identical X values but different Y" do
    let(:one)   { PDF::Reader::TextRun.new(x, y,     width, "A")}
    let(:two)   { PDF::Reader::TextRun.new(x, y + 1, width, "B")}

    it "should return false" do
      one.mergable?(two).should be_false
    end
  end
end

describe PDF::Reader::TextRun, "#+" do
  let(:x)     { 10 }
  let(:y)     { 20 }
  let(:width) { 30 }

  context "when the two runs are within 10pts of each other" do
    let(:one)   { PDF::Reader::TextRun.new(x,          y, width, "A")}
    let(:two)   { PDF::Reader::TextRun.new(one.endx+9, y, width, "B")}

    it "should return a new TextRun with combined data" do
      result = one + two
      result.x.should     == 10
      result.y.should     == 20
      result.width.should == 69
      result.text.should  == "AB"
    end
  end

  context "when the two runs are over 10pts away from each other" do
    let(:one)   { PDF::Reader::TextRun.new(x,           y, width, "A")}
    let(:two)   { PDF::Reader::TextRun.new(one.endx+11, y, width, "B")}

    it "should raise an exception" do
      lambda {
        one + two
      }.should raise_error(ArgumentError)
    end
  end
end

describe PDF::Reader::TextRun, "#<=>" do
  let(:width) { 30 }
  let(:text)  { "Chunky" }

  context "when comparing two runs in the same position" do
    let!(:one) { PDF::Reader::TextRun.new(10, 20, width, text)}
    let!(:two) { PDF::Reader::TextRun.new(10, 20, width, text)}

    it "should return 0" do
      (one <=> two).should == 0
    end
  end

  context "when run two is directly above run one" do
    let!(:one) { PDF::Reader::TextRun.new(10, 10, width, text)}
    let!(:two) { PDF::Reader::TextRun.new(10, 20, width, text)}

    it "should sort two before one" do
      [one, two].sort.should == [two, one]
    end
  end

  context "when run two is directly right of run one" do
    let!(:one) { PDF::Reader::TextRun.new(10, 10, width, text)}
    let!(:two) { PDF::Reader::TextRun.new(20, 10, width, text)}

    it "should sort one before two" do
      [one, two].sort.should == [one, two]
    end
  end

  context "when run two is directly below run one" do
    let!(:one) { PDF::Reader::TextRun.new(10, 10, width, text)}
    let!(:two) { PDF::Reader::TextRun.new(10, 05, width, text)}

    it "should sort one before two" do
      [one, two].sort.should == [one, two]
    end
  end

  context "when run two is directly left of run one" do
    let!(:one) { PDF::Reader::TextRun.new(10, 10, width, text)}
    let!(:two) { PDF::Reader::TextRun.new(5, 10, width, text)}

    it "should sort two before one" do
      [one, two].sort.should == [two, one]
    end
  end

end