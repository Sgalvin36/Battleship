class ComputerBrain
    attr_accessor :keys, :board

    def initialize(player_board)
        @keys = player_board.cells.keys
        @board = player_board
        @level_difficulty = 0
        @first_hit = ""
        @column_row_flop = true
        @miss_1 = ""
        @hits = []
    end

    def computer_input(level_difficulty = @level_difficulty)
        if level_difficulty == 1
            'level one'
        else
            shot = @keys.sample
            @keys.delete(shot)
            computer_shuffle(@keys)
            shot
        end
    end

    def computer_shuffle(keys)
        keys.shuffle!
    end

end