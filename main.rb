rand = Random.new
cmds = ['up', 'right', 'down', 'left']

loop do
  finished = STDIN.gets.to_i
  scores = STDIN.gets.split(' ').map { |w| w.to_i }
  tiles = (1 .. 4).map { |y| STDIN.gets.split(' ').map { |w| w.to_i } }
  if finished == 0
    break
  end
  STDOUT.puts(cmds[rand.max(4)])
  STDOUT.flush()
end
