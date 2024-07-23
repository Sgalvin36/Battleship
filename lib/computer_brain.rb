class ComputerBrain
    attr_accessor :keys, 
                  :board, 
                  :first_hit, 
                  :hits,
                  :last_shot,
                  :miss

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
        @miss = false
    end

    def computer_input(level_difficulty = @level_difficulty)
        if level_difficulty == 1
            level_one_brain
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

    def next_shot(direction, shot)
        var_1 = shot[0].ord
        var_2 = shot[1].to_i
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
        reset_miss
        shot = next_shot(@direction, @last_shot)
        @miss = true if !valid_shot?(shot) || !shot_check(shot)
        change_direction if @miss
        store_hit(shot)
        @keys.delete(shot)
        shot
    end

    def valid_shot?(shot)
        @board.cells.include?(shot) 
    end

    def reset_miss
        @last_shot = @first_hit if @miss
        @miss = false
    end

    def sunk(shot)
        return false unless !@board.cells.ship.sunk?            
        # get all coordinates of ship
        ships_coordinates.each do |coord| 
            @hits.remove(coord)
        end
    end

    def hunt?
        @hits.count > 0
    end

    def shot_pick
        return random_shot unless hunt?
        aimed_shot
    end

    def level_one_brain
        shot = shot_pick
        sunk(shot) unless !shot_check(shot)
        @first_hit = @hits[0]
    end
end