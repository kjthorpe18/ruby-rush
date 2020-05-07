require_relative 'location'
# Main program file, runs the simulation
class Game
  # Constructor - accepts 3 arguments
  def initialize(seed, prospectors, turns)
    @random = Random.new(seed.to_i)
    @prospectors = prospectors.to_i
    @turns = turns.to_i
    @day = 1
    @reals = 0
    @fakes = 0
    @total_moves = 0
  end

  attr_accessor :random
  attr_accessor :prospectors
  attr_accessor :turns
  attr_accessor :reals
  attr_accessor :fakes
  attr_accessor :day

  # Creates prospectors, the map, and runs the game
  def run_game
    prospectors.times do |i|
      reset_vars
      puts "Rubyist#{i + 1} starting in #{@cur_location.name}"
      prospector_search(i)
    end
    exit(0)
  end

  # Runs the simulation for one prospector
  def prospector_search(num)
    while @total_moves < @turns
      found_real, found_fake = search(@random)
      @day += 1
      change_location(@cur_location) unless (found_fake + found_real) != 0
    end
    print_final_stats(num)
    print_final_results
    @day
  end

  # Changes the current location based on its neighbors
  def change_location(location)
    @total_moves += 1
    return location if @total_moves == @turns

    old_loc = location
    @cur_location = location.get_neighbor(random.rand(0..@cur_location.neighbors.length - 1))
    puts "Heading from #{old_loc.name} to #{@cur_location.name}"
    @cur_location
  end

  # Gets a random number of fake and real rubies from a location
  def search(ran)
    found_real = ran.rand(0..@cur_location.max_reals)
    found_fake = ran.rand(0..@cur_location.max_fakes)
    @reals += found_real
    @fakes += found_fake
    day_end(found_real, found_fake)
    [found_real, found_fake]
  end

  # Prints the turn-end stats
  def day_end(real, fake)
    if real.zero? && fake.zero?
      puts "\tFound no rubies or fake rubies in #{@cur_location.name}"
    elsif real > 0 && fake.zero?
      puts "\tFound #{real} #{real != 1 ? 'rubies' : 'ruby'} in #{@cur_location.name}"
    elsif real.zero? && fake > 0
      puts "\tFound #{fake} fake "\
      "#{fake != 1 ? 'rubies' : 'ruby'} in #{@cur_location.name}"
    else
      puts "\tFound #{real} #{real != 1 ? 'rubies' : 'ruby'} "\
      "and #{fake} fake #{fake != 1 ? 'rubies' : 'ruby'} in #{@cur_location.name}"
    end
  end

  # Resets the variables for each prospector
  def reset_vars
    @day = 0
    @reals = 0
    @fakes = 0
    @total_moves = 0
    @cur_location = @enumerable_canyon
  end

  # Creates the map with locations
  def build_map
    @enumerable_canyon = Location.new('Enumerable Canyon', 2, 2)
    @duck_type_beach = Location.new('Duck Type Beach', 3, 3)
    @monkey_patch_city = Location.new('Monkey Patch City', 2, 2)
    @nil_town = Location.new('Nil Town', 0, 4)
    @matzburg = Location.new('Matzburg', 4, 0)
    @hash_crossing = Location.new('Hash Crossing', 3, 3)
    @dynamic_palisades = Location.new('Dynamic Palisades', 3, 3)

    @enumerable_canyon.add_neighbors([@duck_type_beach, @monkey_patch_city])
    @duck_type_beach.add_neighbors([@enumerable_canyon, @matzburg])
    @monkey_patch_city.add_neighbors([@enumerable_canyon, @matzburg, @nil_town])
    @nil_town.add_neighbors([@monkey_patch_city, @hash_crossing])
    @matzburg.add_neighbors([@monkey_patch_city, @hash_crossing, @dynamic_palisades, @duck_type_beach])
    @hash_crossing.add_neighbors([@matzburg, @dynamic_palisades, @nil_town])
    @dynamic_palisades.add_neighbors([@hash_crossing, @matzburg])
    [@enumerable_canyon, @duck_type_beach, @monkey_patch_city, @nil_town, @matzburg, @hash_crossing, @dynamic_palisades]
  end

  def print_final_stats(number)
    return -1 unless number >= 0

    puts "After #{day} #{day > 1 ? 'days' : 'day'}, "\
      "Rubyist #{number + 1} found:\n"\
      "\t#{reals} rubies.\n"\
      "\t#{fakes} fake rubies."
  end

  def print_final_results
    if reals.zero?
      puts 'Going home empty-handed.'
    elsif reals < 10
      puts 'Going home sad.'
    else
      puts 'Going home victorious!'
    end
  end
end
