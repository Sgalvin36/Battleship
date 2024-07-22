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
        @directions = ['left', 'right', 'up', 'down']
        @direction_mode = 0
        @direction = @directions[@direction_mode]
        @miss_1 = ""
    end

    def computer_input(level_difficulty = @level_difficulty)
        if level_difficulty == 1
            'level one'
        else
            random_shot
        end
    end

    def computer_shuffle(keys)
        keys.shuffle!
    end

    def shot_check(shot)
        !@board.cells[shot].empty?
    end

    def random_shot
        shot = @keys.sample
        store_hit(shot)
        @keys.delete(shot)
        computer_shuffle(@keys)
        shot
    end

    def store_hit(shot)
        if shot_check(shot)
            @hits << shot
            @first_hit = @hits[0]
        end
        @last_shot = shot
    end

    def change_direction
        if @direction_mode <= 3
            @direction_mode += 1
        else
            @direction_mode = 0
        end
    end

    def direction
        @direction = @directions[@direction_mode]
    end

    def next_shot(direction)
        var_1 = @last_shot[0].ord
        var_2 = @last_shot[1].to_i
        if direction == 'left'
            var_2 -= 1
        elsif direction == 'right'
            var_2 += 1
        elsif direction == 'up'
            var_1 -= 1
        else
            var_1 += 1
        end
        "#{var_1.chr}#{var_2}"
    end

    def aimed_shot
        shot = next_shot(@direction)
        if valid_shot?(shot)
            store_hit(shot)
            @keys.delete(shot)
            shot
        else
            false
        end
    end

    def valid_shot?(shot)
        @keys.include?(shot) 
    end
end