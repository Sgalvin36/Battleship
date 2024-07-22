require 'spec_helper'

RSpec.describe ComputerBrain do
    before(:each) do
        @player_board = Board.new
        @cruiser = Ship.new("Cruiser", 3)
        @submarine = Ship.new("Submarine", 2)
        @player_board.place(@cruiser, ['A1', 'A2', 'A3'])
        @player_board.place(@submarine, ['B2', 'B3'])
        @computer = ComputerBrain.new(@player_board)
    end

    it 'exists' do
        expect(@computer).to be_a ComputerBrain
    end

    it 'initializes with access to player board' do
    end

end