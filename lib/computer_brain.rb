class ComputerBrain
    attr_accessor :keys, 
                  :board, 
                  :first_hit, 
                  :hits,
                  :last_shot

    def initialize(player_board)
        @keys = player_board.cells.keys
        @board = player_board
        @level_difficulty = 0
        @first_hit = ""
        @hits = []
        @last_shot = ""
        @column_row_flop = true
        @miss_1 = ""
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

    def shot_check(shot)
        !@board.cells[shot].empty?
    end

    def store_hit(shot)
        if shot_check(shot)
            @hits << shot
            @first_hit = @hits[0]
        end
        @last_shot = shot
    end
end