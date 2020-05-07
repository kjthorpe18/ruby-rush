# Location class holds names, neighbors, and a number of real and fake rubies
class Location
  def initialize(name, max_reals, max_fakes)
    @name = name
    @neighbors = []
    @max_reals = max_reals
    @max_fakes = max_fakes
  end

  attr_accessor :name
  attr_accessor :neighbors
  attr_accessor :max_reals
  attr_accessor :max_fakes

  def add_neighbors(locations)
    locations.each do |loc|
      neighbors << loc
    end
  end

  def get_neighbor(index)
    return nil unless index >= 0 && index < neighbors.count

    neighbors[index]
  end
end
