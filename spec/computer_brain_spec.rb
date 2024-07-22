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
        expect(@computer.board).to eq @player_board
    end

    it 'creates an array containing all the cell keys' do
        expect(@computer.keys.length).to eq @player_board.cells.count
    end

    it 'creates an array containing strings' do
        expect(@computer.keys[0]).to eq 'A1'
    end

    describe "#computer_input(level_difficulty)" do
        it 'can get a random shot from the keys' do
            expect(@computer.keys).not_to include @computer.computer_input
        end

        it 'can take a parameter to change the difficulty' do
            expect(@computer.computer_input(1)).to eq 'level one'
        end
    end

    describe "#computer_shuffle" do
        it 'shuffles the shots available' do
            expect(@computer.keys).to eq @player_board.cells.keys
            @computer.computer_shuffle(@computer.keys)

            expect(@computer.keys).not_to eq @player_board.cells.keys
            expect(@computer.keys).to include (@player_board.cells.keys.first && @player_board.cells.keys.last)
        end
    end

    describe "#shot_check" do
        it 'sees if last show was a hit' do
        end

        it 'initiates shot_hunt if last shot was hit' do
        end

        it 'calls another random shot if last shot was miss' do
        end
    end

    describe "shot_hunt" do
        describe "row_hunt" do
            it 'stores last random shot as first hit' do
            end

            it 'assigns all collected hits to array' do
            end

            it 'attempts to fire on cell left of last shot' do
            end

            it 'continues to go left til it misses or edge of map' do
            end

            it 'attempts to fire on right cell from the first hit' do
            end

            it 'continues to go right til it misses or edge of map' do
            end

            it 'breaks the hunt if sunk? returns true' do
            end

            it 'removes all hits associated with sunk ship' do
            end

            it 'continues hunt if any hits are still in array' do
            end

            it 'discovers both misses but has not sunk ship, switch to column hunt' do
            end
        end

        describe "column_hunt" do
            it 'grabs first element from array assings it to first_hit' do
            end

            it 'attempts to fire on cell up from first_hit' do
            end

            it 'continues to fire up until miss or edge of board' do
            end

            it 'attempts to fire on cell down from first_hit' do
            end

            it 'continues to fire down until miss or edge of board' do
            end

            it 'breaks the hunt if sunk? returns true' do
            end

            it 'moves to next element in array and begins process again' do
            end
        end
    end
    # it should store prior shot if it hit a ship
    # if prior shot hit start with left check if it hits
    #   once it doesn't hit or it hits edge of map go left from start point
    #   ship should since when shots get to other edge of map or a miss
    #       if the row of hits does not sink a ship and both edges are found, 
    #       assign all hits to new starts for ships and systematically go up and down columns sinking each ship
    #   if the length of hits is 1 and both misses are found, switch to column start with up

end