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

    describe "#random_shot" do
        it 'returns a random key from array' do
            shot = @computer.random_shot
            expect(@player_board.cells.keys).to include shot
        end

        it 'removes the shot from the available shots' do
            expect(@computer.keys.count).to eq 16
            @computer.random_shot
            expect(@computer.keys.count).to eq 15
        end
    end

    describe "#shot_check" do
        it 'sees if last show was a hit' do
            expect(@computer.shot_check('A1')).to eq true
            expect(@computer.shot_check('C1')).to eq false
        end

        it 'initiates shot_hunt if last shot was hit' do
            first_shot = @computer.shot_check('A1')
            @computer.keys.delete('A1')
            expect(first_shot).to eq true
        end

        it 'calls another random shot if last shot was miss' do
            @computer.shot_check('C1')
            @computer.keys.delete('C1')
            shot = @computer.computer_input
            expect(shot).to be_a String
            expect(shot).not_to eq 'C1'
        end
    end

    describe "shot_hunt" do
        describe "store_shot" do
            it 'stores last random shot as first hit' do
                @computer.store_hit('A1')
                
                expect(@computer.first_hit).to eq 'A1'
                expect(@computer.hits).to eq ['A1']
            end

            it 'doesnt change first_hit with sequential hits' do
                @computer.store_hit('A1')
                @computer.store_hit('A2')

                expect(@computer.first_hit).to eq 'A1'
                expect(@computer.hits).to eq ['A1', 'A2']
            end

            it 'doesnt add to hits if the sequential hit misses' do
                @computer.store_hit('A1')
                @computer.store_hit('C2')

                expect(@computer.first_hit).to eq 'A1'
                expect(@computer.hits).to eq ['A1']
            end

            it 'updates last shot' do
                @computer.store_hit('A1')
                expect(@computer.last_shot).to eq 'A1'

                @computer.store_hit('B2')
                expect(@computer.last_shot).to eq 'B2'
            end
        end

        describe "#direction changer" do
            it 'defaults to left' do
                expect(@computer.direction).to eq 'left'
            end

            it 'can go right' do
                @computer.change_direction
                expect(@computer.direction).to eq 'right'
            end

            it 'can go up' do
                @computer.change_direction
                @computer.change_direction
                expect(@computer.direction).to eq 'up'
            end

            it 'can go down' do
                @computer.change_direction
                @computer.change_direction
                @computer.change_direction
                expect(@computer.direction).to eq 'down'
            end
        end

        describe "next_shot" do
            it 'takes last shot and current direction to determine new shot' do
                @computer.store_hit('A2')
                expect(@computer.next_shot(@computer.direction)).to eq 'A1'
            end

            it 'can move right' do
                @computer.store_hit('B2')
                @computer.change_direction
                expect(@computer.next_shot(@computer.direction)).to eq 'B3'
            end

            it 'can move up' do
                @computer.store_hit('B2')
                @computer.change_direction
                @computer.change_direction
                expect(@computer.next_shot(@computer.direction)).to eq 'A2'
            end

            it 'can move down' do
                @computer.store_hit('A2')
                @computer.change_direction
                @computer.change_direction
                @computer.change_direction
                expect(@computer.next_shot(@computer.direction)).to eq 'B2'
            end
        end

        describe "row_hunt" do
            it 'continues to go left til it misses or edge of map' do
                @computer.store_hit('A2')
            end

            xit 'attempts to fire on right cell from the first hit' do
            end

            xit 'continues to go right til it misses or edge of map' do
            end

            xit 'breaks the hunt if sunk? returns true' do
            end

            xit 'removes all hits associated with sunk ship' do
            end

            xit 'continues hunt if any hits are still in array' do
            end

            xit 'discovers both misses but has not sunk ship, switch to column hunt' do
            end
        end

        describe "column_hunt" do
            xit 'grabs first element from array assings it to first_hit' do
            end

            xit 'attempts to fire on cell up from first_hit' do
            end

            xit 'continues to fire up until miss or edge of board' do
            end

            xit 'attempts to fire on cell down from first_hit' do
            end

            xit 'continues to fire down until miss or edge of board' do
            end

            xit 'breaks the hunt if sunk? returns true' do
            end

            xit 'moves to next element in array and begins process again' do
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