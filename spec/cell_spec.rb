require 'spec_helper'


RSpec.describe Cell do
  before(:each) do
    @cell = Cell.new("B4")
  end

  describe "#initialize" do
    it "can initialize" do
      expect(@cell).to be_an_instance_of(Cell)
      expect(@cell.coordinate).to eq("B4")
    end
  end

  describe "#empty?" do
    it "returns true if empty" do
      expect(@cell.empty?).to eq(true)
    end

    xit "returns false if not empty" do
      expect(@cell.empty?).to eq(false)
    end
  end

end