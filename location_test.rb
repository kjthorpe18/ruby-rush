require 'minitest/autorun'
require_relative 'location'

class LocationTest < Minitest::Test
  
  # UNIT TESTS FOR METHOD add_neighbor(location)
  # Tests that a location can accept a valid neighbor
  # and reflects this in the count
  def test_add_neighbor
  	loc = Location.new("Scranton", 1, 1)
  	assert_equal 0, loc.neighbors.count
  	loc.add_neighbors([Minitest::Mock.new("mock")])
  	assert_equal 1, loc.neighbors.count
  end

  # UNIT TESTS FOR METHOD get_neighbor(index)
  # Equivalence classes:
  # index = 0..neighbors.count-1 -> returns location
  # index != 0..neighbors.count-1 -> returns nil

  # Tests that a neighbor can be retrieved from a location by index
  def test_get_neighbor
    loc = Location.new("Scranton", 1, 1)
    mock_neighbor = Minitest::Mock.new("mock")
    loc.add_neighbors([mock_neighbor])
    retrieved_neighbor = loc.get_neighbor(0)
    assert_equal mock_neighbor, retrieved_neighbor
  end

  # Tests a low invalid index returns nil
  def test_get_nonexistent_neighbor_low
    loc = Location.new("Scranton", 1, 1)
    mock_neighbor = Minitest::Mock.new("mock")
    loc.add_neighbors([mock_neighbor])
    retrieved_neighbor = loc.get_neighbor(-1)
    assert_nil retrieved_neighbor
  end

  # Tests a high invalid index returns nil
  def test_get_nonexistent_neighbor_high
    loc = Location.new("Scranton", 1, 1)
    mock_neighbor = Minitest::Mock.new("mock")
    loc.add_neighbors([mock_neighbor])
    retrieved_neighbor = loc.get_neighbor(1)
    assert_nil retrieved_neighbor
  end
end
