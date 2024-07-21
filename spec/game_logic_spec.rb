require 'spec_helper'

RSpec.describe GameLogic do
    before(:each) do
      @board = Board.new
      @cruiser = Ship.new("Cruiser", 3)
      @submarine = Ship.new("Submarine", 2)
      
    end

    describe 'Initialize' do
        it 'exists' do
            expect(@board).to be_an_instance_of Board
        end
    end

    describe '#game_loop' do
        before(:each) do
            @gameplay = GameLogic.new
            @gameplay.player_board = Board.new
            @gameplay.computer_board = Board.new
            @cruiser = Ship.new('Cruiser', 3)
            @submarine = Ship.new('Submarine', 2)

            @gameplay.player_board.place(@cruiser, ['A1', 'A2', 'A3'])
            @gameplay.player_board.place(@submarine, ['C1', 'C2'])
            @gameplay.computer_board.place(@cruiser, ['A1', 'A2', 'A3'])
            @gameplay.computer_board.place(@submarine, ['C1', 'C2'])
        end

        it 'continues while ships on user side still stand' do
        end

        it 'continues while ships on computer side still stand' do
        end

        it 'ends when all ships on user side are sunk' do
        end

        it 'ends when all ships on computer side are sunk' do
        end

        it 'gets user input for shot' do  

        end

        it 'checks if shot is valid or been shot before' do
        end

        it 'has computer take a shot' do
        end

        it 'checks both shots for hits' do
        end

        it 'updates ship if hit' do
        end

        it 'checks if ship is sunk' do
        end

        it 'checks if sunk ship is last standing ship' do
        end

        it 'updates both boards' do
        end

        it 'gives user feedback on shots fired' do
        end

        it 'cycles back to top of turn' do
        end
    end
end