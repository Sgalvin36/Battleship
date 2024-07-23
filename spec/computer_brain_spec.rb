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

        xit 'can take a parameter to change the difficulty' do
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

                @computer.store_hit('C2')
                expect(@computer.last_shot).to eq 'C2'
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
                expect(@computer.next_shot(@computer.direction, 'A2')).to eq 'A1'
            end

            it 'can move right' do
                @computer.store_hit('B2')
                @computer.change_direction
                expect(@computer.next_shot(@computer.direction, 'B2')).to eq 'B3'
            end

            it 'can move up' do
                @computer.store_hit('B2')
                @computer.change_direction
                @computer.change_direction
                expect(@computer.next_shot(@computer.direction, 'B2')).to eq 'A2'
            end

            it 'can move down' do
                @computer.store_hit('A2')
                @computer.change_direction
                @computer.change_direction
                @computer.change_direction
                expect(@computer.next_shot(@computer.direction, 'A2')).to eq 'B2'
            end
        end

        describe "#aimed_shot" do
            it 'finds the next shot' do
                @computer.store_hit('A2')
                expect(@computer.aimed_shot).to eq 'A1'
            end

            it 'checks if the shot is on the board' do
                @computer.store_hit('A2')
                expect(@computer.valid_shot?(@computer.next_shot(@computer.direction, 'A2'))).to eq true
            end

            it 'removes the shot from available pool' do
                @computer.store_hit('A2')
                @computer.keys.delete('A2')
                @computer.aimed_shot
                expect(@computer.keys.count).to eq 14
            end

            it 'checks if last shot is hit and moves on without changing' do
                @computer.store_hit('A2')
                @computer.keys.delete('A2')
                expect(@computer.last_shot).to eq 'A2'
                expect(@computer.direction).to eq 'left'
                @computer.aimed_shot

                expect(@computer.last_shot).to eq 'A1'
                expect(@computer.direction).to eq 'left'
            end

            it 'checks if last shot is miss and changes direction' do
                @computer.store_hit('B2')
                @computer.keys.delete('B2')
                expect(@computer.last_shot).to eq 'B2'
                expect(@computer.direction).to eq 'left'
                expect(@computer.miss).to eq false
                @computer.aimed_shot

                expect(@computer.last_shot).to eq 'B1'
                expect(@computer.direction).to eq 'right'
                expect(@computer.miss).to eq true
            end

            it 'attempts to fire on right cell from the first hit' do
                @computer.store_hit('A2')
                @computer.keys.delete('A2')
                shot = @computer.aimed_shot
                
                expect(shot).to be_truthy
                expect(shot).to eq 'A1'
            end

            it 'continues to go right til edge of map' do
                @computer.store_hit('A1')
                @computer.keys.delete('A1')
                # require 'pry';binding.pry
                shot = @computer.aimed_shot
                
                expect(shot).to eq 'A2'
            end

            it 'continues to go right til it misses' do
                @computer.store_hit('B2')
                @computer.keys.delete('B2')
                @computer.aimed_shot
                
                expect(@computer.miss).to eq true
            end

            it 'changes the direction on a miss' do
                @computer.store_hit('B2')
                @computer.keys.delete('B2')
                @computer.aimed_shot

                expect(@computer.direction).to eq 'right'
            end

            it 'should go right with the shot after a miss' do
                @computer.store_hit('B2')
                @computer.keys.delete('B2')
                @computer.aimed_shot
                
                expect(@computer.miss).to eq true
                expect(@computer.direction).to eq 'right'
                expect(@computer.last_shot).to eq 'B1'
                expect(@computer.first_hit).to eq 'B2'

                expect(@computer.aimed_shot).to eq 'B3'
            end

            it 'should keep going right until it misses or sinks' do
                @computer.store_hit('B2')
                @computer.keys.delete('B2')
                @computer.
                expect(@computer.board.cells['B2'].ship.sunk?).to eq false
                shot = @computer.aimed_shot #B1
                expect(@computer.miss).to eq true
                shot = @computer.aimed_shot

                expect(@computer.board.cells[shot].ship.sunk?).to eq true
            end
        end

        describe '#valid_shot()' do
            xit 'takes a shot and checks that its on the board' do
                expect(@computer.valid_shot?("B3")).to eq true
            end

            xit 'returns false if the shot is out of bounds' do
                expect(@computer.valid_shot?("B0")).to eq false
            end
        end

        describe '#reset_miss' do
            xit 'does not set last_shot to first hit if miss = false' do
                @computer.last_shot = 'A1'
                @computer.first_hit = 'B3'
                @computer.reset_miss

                expect(@computer.last_shot).to eq 'A1'
            end

            xit 'does set last_shot to first_hit if miss = true' do
                @computer.last_shot = 'A1'
                @computer.first_hit = 'B3'
                @computer.miss = true
                @computer.reset_miss

                expect(@computer.last_shot).to eq 'B3'
            end
        end

        describe "#hunt?" do
            xit 'returns true if @hits has any values' do
                @computer.hits << ['A3']
                expect(@computer.hunt?).to eq true
            end

            xit 'returns false if @hits has an empty array' do
                expect(@computer.hunt?).to eq false
            end
        end

        describe "#shot_pick" do
            xit 'calls a random shot if hunt? is false' do
                expect(@computer.shot_pick).to be_a String
            end

            xit 'calls an aimed shot if hunt is true' do
                @computer.store_hit('B2')
                @computer.keys.delete('B2')
                expect(@computer.shot_pick).to eq 'B1'
            end
        end

        # describe "#hunt" do
    
        #     # it 'should go right with the shot after a miss' do
        #     #     @computer.store_hit('B2')
        #     #     @computer.keys.delete('B2')
                
        #     #     expect(shot).to eq 'B3'
        #     # # end

        #     # xit 'breaks the hunt if sunk? returns true' do
        #     # end

        #     # xit 'removes all hits associated with sunk ship' do
        #     # end

        #     # xit 'continues hunt if any hits are still in array' do
        #     # end

        #     # xit 'discovers both misses but has not sunk ship, switch to column hunt' do
        #     # end
        # end
    end
end