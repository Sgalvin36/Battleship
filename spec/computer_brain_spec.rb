require 'spec_helper'

RSpec.describe ComputerBrain do
    it 'exists' do
        computer = ComputerBrain.new
        expect(computer).to be_a ComputerBrain
    end
end