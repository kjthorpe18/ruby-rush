require_relative 'game.rb'

def arg_check(args)
  return exit_program if args[1].to_i <= 0 || args[2].to_i <= 0 || args.count != 3
  args
end

def exit_program
  puts "Usage:\nruby gold_rush.rb *seed* *num_prospectors* *num_turns*\n*seed* should be an integer\n"\
  "*num_prospectors* should be a non-negative integer\n*num_turns* should be a non-negative integer"
  exit(1)
end

arg_check(ARGV)
game = Game.new(ARGV[0], ARGV[1], ARGV[2])
game.build_map
game.run_game
exit(0)
