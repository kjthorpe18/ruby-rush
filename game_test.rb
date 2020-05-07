require 'minitest/autorun'
require_relative 'game'

class GameTest < Minitest::Test

  def setup
    @game = Game.new(1, 2, 2)
    @game.build_map
    @game.reset_vars
  end

  # Tests that Game is initialized correctly, with correct start
  # values for variables
  def test_initialize
    assert @game.is_a?(Game)
    assert @game.random.is_a?(Random)
    assert_equal 2, @game.prospectors
    assert_equal 2, @game.turns
  end

  # UNIT TESTS FOR METHOD print_final_results
  # Equivalence classes
  # reals = 0 -> outputs "Going home empty-handed."
  # reals 1..9 -> outputs "Going home sad."
  # reals > 9 -> outputs "Going home victorious!"

  # Tests if 0 rubies found "Going home empty-handed." will be output
  # EDGE CASE
  def test_no_rubies_result
    def @game.reals; 0; end
    assert_output(/Going home empty-handed./) { @game.print_final_results }
  end

  # Tests if 1..9 rubies found "Going home sad." will be output
  def test_some_rubies_result
    def @game.reals; 9; end
    assert_output(/Going home sad./) { @game.print_final_results }
  end

  # Tests if > 9 rubies found "Going home victorious!" will be output
  # EDGE CASE
  def test_many_rubies_result
    def @game.reals; 10; end
    assert_output(/Going home victorious!/) { @game.print_final_results }
  end

  # UNIT TESTS FOR METHOD print_final_stats(num)
  # Equivalence classes:
  # num >= 0 -> Outputs Rubyist's name
  # num < 0 -> Returns a -1 error

  # Tests that if given 0, Rubyist 1 will be in output
  def test_print_stats
    assert_output(/Rubyist 1/) {@game.print_final_stats(0)}
  end

  # Tests that only positive Rubyist indeces are accepted, will return a -1
  # EDGE CASE
  def test_print_stats_invalid_index
    assert_equal -1, @game.print_final_stats(-1)
  end

  # UNIT TESTS FOR METHOD day_end(real, fake)
  # Equivalence classes:
  # real == 0, fake == 0 -> prints none found
  # real == 1, fake == 0 -> prints num real found singular form
  # real == 0, fake == 1 -> prints num fake found singular form
  # real == 1, fake == 1 -> prints num both found singular form
  # real > 1, fake == 0 -> prints num real found plural form
  # real == 0, fake > 1 -> prints num fake found plural form
  # real > 1, fake > 1 -> prints num both found plural form

  # Tests displaying none of each found
  def test_none_found
    assert_output(/\tFound no rubies or fake rubies in Enumerable Canyon/) { @game.day_end(0, 0) }
  end

  # Tests displaying num real found
  def test_num_real_found
    assert_output(/\tFound 1 ruby in Enumerable Canyon/) { @game.day_end(1, 0) }
  end

  # Tests displaying num fake found
  def test_num_fake_found
    assert_output(/\tFound 1 fake ruby in Enumerable Canyon/) { @game.day_end(0, 1) }
  end

  # Tests displaying num of both found
  def test_num_both_found
    assert_output(/\tFound 1 ruby and 1 fake ruby in Enumerable Canyon/) { @game.day_end(1, 1) }
  end

  # Tests displaying num real found plural
  def test_num_real_found_plural
    assert_output(/\tFound 2 rubies in Enumerable Canyon/) { @game.day_end(2, 0) }
  end
  
  # Tests displaying num fake found plural
  def test_num_fake_found_plural
    assert_output(/\tFound 2 fake rubies in Enumerable Canyon/) { @game.day_end(0, 2) }
  end

  # Tests displaying num both found plural
  # EDGE CASE
  def test_num_both_found_plural
    assert_output(/\tFound 2 rubies and 2 fake rubies in Enumerable Canyon/) { @game.day_end(2, 2) }
  end

  # UNIT TESTS FOR METHOD search(ran)
  # Tests that the found rubies and fakes are the random results or a search
  def test_search
    mocked_random = Minitest::Mock.new('random')
    def mocked_random.rand(random_num); return 1; end;
    assert_equal([1, 1], @game.search(mocked_random))
  end

  # UNIT TESTS FOR METHOD prospector_search(num)
  # Tests that the day is updated as the prospector searches (should go more than one day)
  def test_prospector_search
    game = Game.new(1, 1, 10)
    def @game.search(num); [0, 0]; end;
    def @game.print_final_results; ""; end
    def @game.print_final_stats(num); ""; end
    assert_operator 1, :<, @game.prospector_search(0)
  end
end
