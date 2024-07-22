require 'spec_helper'

RSpec.describe Board do
    before(:each) do
      @board = Board.new
      @cruiser = Ship.new("Cruiser", 3)
      @submarine = Ship.new("Submarine", 2)
    end

    describe 'Initialize' do
        it 'exists' do
            expect(@board).to be_an_instance_of Board
        end

        it 'creates board cells, and its equal to a hash' do
            expect(@board.cells).to be_truthy
            expect(@board.cells.class).to eq(Hash)
        end
        it 'The board cells values are cell objects ' do
            expect(@board.cells["A1"]).to be_an_instance_of Cell
            expect(@board.cells["A1"].coordinate).to eq("A1")
        end

    end

    describe '#valid_coordinates?' do
        describe '#valid_coordinate?' do
            it 'verifies the arguemnt is on the board' do
                expect(@board.valid_coordinate?("A1")).to eq true
                expect(@board.valid_coordinate?("B3")).to eq true
            end

            it 'catches if the arguement is not on the board' do
                expect(@board.valid_coordinate?("A22")).to eq false
                expect(@board.valid_coordinate?("dog")).to eq false
            end
        end

        describe '#valid_coordinates?' do
            it 'verifies if each element inside an array is on the board' do
                coordinates_1 = ['A1', 'A2', 'A3']
                coordinates_2 = ['B1', 'C1', 'D1']

                expect(@board.valid_coordinates?(coordinates_1)).to eq true
                expect(@board.valid_coordinates?(coordinates_2)).to eq true
            end

            it 'catches if an element inside an array is not on the board' do
                coordinates_1 = ['A1', 'A5', 'E1']
                coordinates_2 = ['dog']
                coordinates_3 = [3]

                expect(@board.valid_coordinates?(coordinates_1)).to eq false
                expect(@board.valid_coordinates?(coordinates_2)).to eq false
                expect(@board.valid_coordinates?(coordinates_3)).to eq false
            end

        end
    end
  
    describe '#valid_placement?' do
        describe '#match_length?' do
            it 'reads the arguments' do
                coordinates = ['A1', 'B1', 'C1']
                expect(@board.match_length?(@cruiser, coordinates)).to eq true
            end

            it 'returns false if argument lengths dont match' do
                coordinates = ['A1', 'C1']
                expect(@board.match_length?(@cruiser, coordinates)).to eq false
            end
        end

        describe '#straight_line?' do
            it 'checks all the coordinates first element returns true if they match' do
                coordinates = ['A1', 'A2', 'A3']
                expect(@board.straight_line(coordinates)).to eq({"columns" => ['1','2','3']})
            end

            it 'checks all the coordinates first element returns false if they dont match' do
                coordinates = ['A1', 'B2', 'C3']
                expect(@board.straight_line(coordinates)).to eq false 
            end

            it 'checks all the coordinates second element returns true if they match' do
                coordinates = ['A1', 'B1', 'C1']
                expect(@board.straight_line(coordinates)).to eq({'rows' => ['A','B','C']})
            end

            it 'checks all the coordinates second element returns false if they match' do
                coordinates = ['A1', 'B2', 'C3']
                expect(@board.straight_line(coordinates)).to eq false
            end
        end


        describe '#consecutive_check?' do
            describe '#row_consecutive?' do
                it "checks that a row is conesecutive, returns true if it is" do
                    row = ['A','B','C']
                    expect(@board.row_consecutive?(row)).to eq true
                end

                it "checks that a row is consecutive, returns false if it isn't" do
                    row = ['A','B','D']
                    expect(@board.row_consecutive?(row)).to eq false
                end

                it "is dynamic and works with any size row" do
                    small_good_row = ['A','B']
                    large_good_row = ['A','B','C','D']
                    small_bad_row = ['A','C']
                    large_bad_row = ['A','B','D','E']

                    expect(@board.row_consecutive?(small_good_row)).to eq true
                    expect(@board.row_consecutive?(large_good_row)).to eq true
                    expect(@board.row_consecutive?(small_bad_row)).to eq false
                    expect(@board.row_consecutive?(large_bad_row)).to eq false
                end

                it "works with unordered arrays" do
                    good_row = ['B','C','A']
                    bad_row = ['D', 'A', 'B']

                    expect(@board.row_consecutive?(good_row)).to eq true
                    expect(@board.row_consecutive?(bad_row)).to eq false
                end
            end

            describe '#column_consecutive?' do
                it "checks that a column is consecutive, returns true if it is" do
                    column = [1, 2, 3]
                    expect(@board.column_consecutive?(column)).to eq true
                end

                it "checks that a column is consecutive, returns false if it isn't" do
                    column = [1, 2, 4]
                    expect(@board.column_consecutive?(column)).to eq false
                end

                it "is dynamic and works with any size column" do
                    small_good_column = [1, 2]
                    large_good_column = [1, 2, 3, 4]
                    small_bad_column = [1, 3]
                    large_bad_column = [1, 2, 4, 5]

                    expect(@board.column_consecutive?(small_good_column)).to eq true
                    expect(@board.column_consecutive?(large_good_column)).to eq true
                    expect(@board.column_consecutive?(small_bad_column)).to eq false
                    expect(@board.column_consecutive?(large_bad_column)).to eq false
                end

                it "works with unordered arrays" do
                    good_column = [2, 3, 1]
                    bad_column = [4, 1, 2]

                    expect(@board.column_consecutive?(good_column)).to eq true
                    expect(@board.column_consecutive?(bad_column)).to eq false
                end
            end

            describe "#consecutive_check?" do
                it 'checks if the arguement is a row or column and then test if they are consecutive, returns true if consecutive' do
                    row = {"rows" => ['A','B','C']}
                    column = {"columns" => ['1','2','3']}

                    expect(@board.consecutive_check?(row)).to eq true
                    expect(@board.consecutive_check?(column)).to eq true
                end

                it 'checks if the arguement is a row or column and then test if they are consecutive, returns false if not consecutive' do
                    row = {"rows" => ['A','B','D']}
                    column = {"columns" => ['1','2','4']}

                    expect(@board.consecutive_check?(row)).to eq false
                    expect(@board.consecutive_check?(column)).to eq false
                end

                it 'returns false if it does not recognize the arguement data' do
                    row = ['A','B','C']
                    column = {"ship" => ['1','2','3']}

                    expect(@board.consecutive_check?(row)).to eq false
                    expect(@board.consecutive_check?(column)).to eq false
                end
            end
        end

        describe '#overlap?' do
            it 'returns true if any cell already contains a ship' do
                @board.cells['A1'].place_ship(@submarine)
                @board.cells['A2'].place_ship(@submarine)
                coordinates = ['A1', 'A2', 'A3']

                expect(@board.overlap?(coordinates)).to eq true
            end

            it 'returns false if all cells are empty' do
                coordinates = ['A1', 'A2', 'A3']

                expect(@board.overlap?(coordinates)).to eq false
            end
            
            it 'works even with other ships on the board' do
                @board.cells['A1'].place_ship(@submarine)
                @board.cells['A2'].place_ship(@submarine)
                coordinates = ['C1', 'C2', 'C3']

                expect(@board.overlap?(coordinates)).to eq false
            end
        end

        describe "#valid_placement?" do
            it "checks if the placement is valid for a ship, returns true if valid" do
                coordinates_1 = ['A1','A2','A3']
                coordinates_2 = ['A1','B1','C1']
                
                expect(@board.valid_placement?(@cruiser, coordinates_1)).to eq true
                expect(@board.valid_placement?(@cruiser, coordinates_2)).to eq true
            end

            it "checks if the placement is valid for a ship, returns false if ship length & coordinates do match" do
                coordinates = ['A1','A2']
                expect(@board.valid_placement?(@cruiser, coordinates)).to eq false
            end

            it "checks if the placement is valid for a ship, returns false if coordinates are not valid" do
                coordinates = ['B1','D1','E1']
                expect(@board.valid_placement?(@cruiser, coordinates)).to eq false
            end

            it "checks if the placement is valid for a ship, returns false if the all coordinates are not in the same column or row" do
                coordinates = ['A1', 'B2', 'A3']
                expect(@board.valid_placement?(@cruiser, coordinates)).to eq false
            end

            it "checks if the placement is valid for a ship, returns false if the coordinates are not consecutive" do
                coordinates = ['A1', 'A3', 'A4']
                expect(@board.valid_placement?(@cruiser, coordinates)).to eq false
            end

            it "checks if the placement is valid for a ship, returns false if the coordinates are overlapping with another ship"  do
                @board.cells['A1'].place_ship(@submarine)
                @board.cells['A2'].place_ship(@submarine)
                coordinates = ['A1','A2','A3']

                expect(@board.valid_placement?(@cruiser, coordinates)).to eq false
            end
        end
    end



    describe '#place' do
        it "can place a ship in the cells with matching coordinates" do
            coordinates = ['A1', 'A2', 'A3']
            @board.place(@cruiser, coordinates)

            expect(@board.cells[coordinates[0]].ship).to eq @cruiser
            expect(@board.cells[coordinates[1]].ship).to eq @cruiser
            expect(@board.cells[coordinates[2]].ship).to eq @cruiser
        end

        it "won't place a ship in the cells if the coordinates are not valid" do
            coordinates = ['A1', 'B2', 'A3']
            @board.place(@cruiser, coordinates)

            expect(@board.cells[coordinates[0]].empty?).to eq true
            expect(@board.cells[coordinates[1]].empty?).to eq true
            expect(@board.cells[coordinates[2]].empty?).to eq true
        end

        it "returns false if the coordinates are not valid" do
            coordinates = ['A1', 'B2', 'A3']
            expect(@board.place(@cruiser, coordinates)).to eq false
        end
    end

    describe '#render' do
        describe '#render_column_title' do
            it "dynamically creates a row with the amount column titles" do
                larger_board = Board.new("D", 6)
            
                expect(@board.render_column_title).to eq "  1 2 3 4"
                expect(larger_board.render_column_title).to eq "  1 2 3 4 5 6"
            end
        end

        describe "#render_body" do 
            it "dynamically renders each row title and cell state" do
                larger_board = Board.new("E",7)

                expect(@board.render_body).to eq "\nA . . . .\nB . . . .\nC . . . .\nD . . . ."
                expect(larger_board.render_body).to eq "\nA . . . . . . .\nB . . . . . . .\nC . . . . . . .\nD . . . . . . .\nE . . . . . . ."
            end

            it "is rendering the actualy state of the cell" do
                @board.cells['C2'].fire_upon
                @board.place(@submarine, ['B2','B3'])

                expect(@board.render_body).to eq "\nA . . . .\nB . . . .\nC . M . .\nD . . . ."
            end

            it "can take true as an arugement to display ships" do
                @board.cells['C2'].fire_upon
                @board.place(@submarine, ['B2','B3'])

                expect(@board.render_body(true)).to eq "\nA . . . .\nB . S S .\nC . M . .\nD . . . ."
            end

        end

        describe "#render" do
            it "dynamically renders entire board" do
                larger_board = Board.new('E', 5)

                expect(@board.render).to eq "  1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . ."
                expect(larger_board.render).to eq "  1 2 3 4 5\nA . . . . .\nB . . . . .\nC . . . . .\nD . . . . .\nE . . . . ."
            end

            it "can take true as anrguement to disply ships" do
                @board.cells['A3'].fire_upon
                @board.place(@submarine, ['D2','C2'])

                expect(@board.render(true)).to eq "  1 2 3 4\nA . . M .\nB . . . .\nC . S . .\nD . S . ."
            end
        end
    end
end
